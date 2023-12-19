clc
clear

%generate globals for sprites
global ship_top;
global ship_middle;
global ship_bottom;
global grid;
global blank;
global com_hit;
global ship_top_burnt;
global ship_middle_burnt;
global ship_bottom_burnt;
global wrong_guess;

ship_top = 1;
ship_middle = 2;
ship_bottom = 3;
grid = 4;
blank = 5;
com_hit = 10;
ship_top_burnt = 7;
ship_middle_burnt = 6;
ship_bottom_burnt = 8;
wrong_guess = 9;

% generate engine
blue = [0,191,255];
scene = simpleGameEngine("sprites.png", 32,32,4,blue);

% generate title scene
bg = blank * ones(10,22);
fg = blank * ones(10,22);
drawScene(scene, bg, fg);

% generating text
title = text(1000,600,'Battleship','FontSize',60);
subtitle = text(1000,700,'Type space to begin', 'FontSize',20);

%exit title screen
k = getKeyboardInput(scene);
if k == "space"
    title.Visible = 'off';
    subtitle.Visible = 'off';
end
%lets use set up their fleet, randomly generates the computer's fleet, and
%starts the actual game
p_ships = layout_player_ships(scene);
c_ships = layout_com_ships()
scene = turns(scene, p_ships, c_ships);

% lets the player set the position of the length 2 ship, the length 3 ship,
% the second length 3 ship, the length 4 ship, and then the length 5
% ship.
%
% scene with player ships (left) and com ships (right) is displayed.
%
% outputs p_ships ship with positions of all of the ship pieces.
% every row in p_ships is a ship
% the first column is the length of the ship. the rest of the columns
% are the locations of the ships. zeros after the first column should be
% ignored
function p_ships = layout_player_ships(scene)
% access globals
global blank;
global ship_top;
global ship_middle;
global ship_bottom;


%let the player know
title = text(1500,500,"Place your ships on the map!", FontSize=25);

%setup p_ships to be updated
p_ships = zeros(5,6);

% setting up the grid. empty foreground for now
bg = horzcat(4*ones(10,10), blank * ones(10,12));
fg = blank * ones(10,22);
drawScene(scene, bg, fg)

% these are the lengths of the ships the player and computer have in
% their fleet
ship_lengths = [2,3,3,4,5];

i = 1;
while i <= length(ship_lengths)
    % get input
    [r,c,b] = getMouseInput(scene);

    % check for validity
    if b == 1 && c >= 1 && c <= 10 && (r+ship_lengths(i) - 1) <= 10 ...
            && all(fg(r:(r+ship_lengths(i) - 1),c) ==blank)

        % display all ship pieces on the map
        for j = 1:ship_lengths(i)
            % calculate what part of the grid the ship piece is on
            % and store this in p_ships
            pos = r + (c-1)*10;
            p_ships(i,j+1) = pos + (j - 1);

            % row of the ship piece keeps increasing with
            % each iteration
            row = r + (j - 1);

            % check if it's the top/middle/bottom of the ship
            switch j
                case 1
                    fg(row,c) = ship_top;
                case 2 && ship_lengths(i) ~= 2
                    fg(row,c) = ship_middle;
                case ship_lengths(i)
                    fg(row,c) = ship_bottom;
                otherwise
                    fg(row,c) = ship_middle;
            end

            % draw the ship so far
            drawScene(scene, bg, fg)
        end

        %store length information in array
        p_ships(i,1) = ship_lengths(i);
    else
        % give player a warning
        title.String = "Invalid ship placement!";
        title.Visible = 'on';
        pause(1.5);
        title.String = 'Place your ships on the map!';
        i = i - 1;
    end
    i = i+1;
end

%don't need this text anymore
title.Visible='off';
end

% generates ships that the player can try to sink using random
% rows and columns.
%
% doesn't need any inputs as it uses its own 10x10 grid
% to generate ships with.
%
% outputs c_ships. similar to p_ships
function c_ships = layout_com_ships()

% setup c_ships to be updated
c_ships = zeros(5, 6);

% these are the lengths of the ships the player and computer have in
% their fleet
ship_lengths = [2, 3, 3, 4, 5];

% use this to conveniently store position of ship pieces
pos = 0;

i = 1;
while i <= length(ship_lengths)
    % randomly generate rows and columns
    r = randi(10);
    c = randi(10);

    pos = r + (c-1)*10;

    % check for validity
    if all(c_ships(i,:) == 0) && (r + ship_lengths(i) - 1) <= 10 &&...
            ~any(ismember(pos:pos+(ship_lengths(i) - 1),c_ships(:,2:end)))
        for j = 1:ship_lengths(i)
            % store position information in c_ships
            pos = r + (c-1)*10;
            c_ships(i,j+1) = pos + (j - 1);
        end

        % store length information in array
        c_ships(i,1) = ship_lengths(i);
    else
        % try again but don't count as another iteration
        i = i - 1;
    end

    i = i + 1;
end
end


%the computer randomly generates x and y coordinates that it has not
%guessed already and updates the score acordingly
%
%fg is the "foreground"; this is where guess indicators and ship pieces are
%printed on top of the grid. fg is updated to show whether a ship piece
% was hit or not
%
%score just keeps track of who is winning. a hit for the computer
% results in the player losing 1 point
%
%p_ships has been generated in layout_player_ships()
function [fg, score] = com_guess(fg, p_ships, score)
% access globals
global ship_bottom;
global ship_bottom_burnt;
global ship_top;
global ship_top_burnt;
global ship_middle_burnt;
global ship_middle;
global wrong_guess;
global blank;

%generate random coordinates
r = randi(10);
c = randi(10);

%check if computer has not already guessed this location
if ~ismember(fg(r,c),[ship_top_burnt wrong_guess ship_bottom_burnt ...
        ship_middle_burnt])
    % check computer's guess and update score accordingly
    switch fg(r,c)
        case ship_bottom
            fg(r,c) = ship_bottom_burnt;
            score = score - 1;
        case ship_top
            fg(r,c) = ship_top_burnt;
            score = score - 1;
        case ship_middle
            fg(r,c) = ship_middle_burnt;
            score = score - 1;
        case blank
            fg(r,c) = wrong_guess;
    end
end
end

%check_sunk returns a 1 or 0 if a new ship has been sunk.
%
%sunk is the returned variable.
%
%ships_to_skip is a vector that keeps track of which ships (rows in ships)
% has been sunk
%
%ships is an array that has information about the length of ships and the
%positions of the ship pieces
%
%board_side is the part of the scene that has either the player/com's side
%of the board
function [sunk, ships_to_skip] = check_sunk(ships, board_side, ...
    ships_to_skip)
%access globals
global com_hit;

%initialize sunk variable to return
sunk = 0;

%iterate through rows (ships)
for i = 1:size(ships,1)
    %skip ships that have already been checked
    if ships_to_skip(i)
        continue
    end

    %iterate through positions (columns)
    for j = 2:size(ships,2)
        % ignore 0s, they are placeholders
        if ships(i,j) == 0
            continue
        end

        % check individual ship piece
        if board_side(ships(i,j)) == com_hit
            sunk = 1;
        else
            sunk = 0;
            break
        end
    end

    %if one of the ships has already been sunk no further checking is
    % required
    if sunk == 1
        ships_to_skip(i) = 1;
        break
    end
end
end


%resets the game so that the player can play again.
function scene =  reset_game(scene, fg, bg, winner, score_label, ...
    score_value, guesses_label, guesses_value)
global blank;
k = getKeyboardInput(scene);
fg(:) = blank;
bg(:) = blank;

if k == "space"
    winner.Visible = "off";
    score_label.Visible = "off";
    score_value.Visible = "off";
    guesses_label.Visible = "off";
    guesses_value.Visible = "off";

    p_ships = layout_player_ships(scene);
    c_ships = layout_com_ships();
    scene = turns(scene, p_ships, c_ships);

end

end

%the player and computer take turns guessing the locations of their
%opponent's ships. the player has 50 guesses. if they run out of guesses or
%if the computer sinks their fleet then they lose.
%
%scene is redrawn every turn to reflect guesses
%
%p_ships and c_ships have player and computer's fleet information
function scene = turns(scene, p_ships, c_ships)
%access globals
global ship_top;
global blank;
global com_hit;
global ship_middle;
global ship_bottom;
global wrong_guess;

%initialize bg and fg. splitting the scene into 3 areas: the player's map,
%the computer's map and the middle with score/guess information
bg = horzcat(4*ones(10,10), 5*ones(10,2),4*ones(10,10));
fg = 5*ones(10,22);

% using p_ships to redraw player's fleet
for i = 1:5
    ship = p_ships(i,2:end);

    for j = 1:p_ships(i,1)
        pos = ship(j);

        % skip 0, these are placeholder elements
        if pos == 0
            continue
        end

        % using index to figure out whether the position is the
        % top/middle/bottom of the ship
        switch j
            case 1
                fg(pos) = ship_top;
            case p_ships(i,1)
                fg(pos) = ship_bottom;
            otherwise
                fg(pos)= ship_middle;
        end
    end
end
drawScene(scene, bg, fg);

% display information about score and guesses remaining
score_label = text(1300,200,"score",FontSize=20);
score = 0;
score_value = text(1300,300,num2str(score),fontSize=20);

guesses_label = text(1300,600,"guesses left",FontSize=15);
guesses = 50;
guesses_value = text(1300,700,num2str(guesses),fontSize=20);

%initialize sunk variables to keep updating
c_sunk = 0;
p_sunk = 0;

%initialize list of ships to skip checking for check_sunk
c_ships_to_skip = zeros(1,5);
p_ships_to_skip = zeros(1,5);

%setup flag to check if someone sunk someone else's fleet,
%this flag will immediately end the game if true
fleet_completely_sunk = false;
% main loop of the game. player gets 50 guesses
while guesses >= 1 && ~fleet_completely_sunk

    % get input
    [r,c,b] = getMouseInput(scene);

    % check validity and display warning
    if (c >= 13 && c <= 22) && b == 1 && fg(r,c) == 5
        % get position of guess
        pos = (c-13)*10  + r;

        % check if guess position is any of the computer's ship pieces
        if ismember(pos, c_ships)
            %update score
            score = score + 1;

            %print an 'O' so ship's shape and lenght are not given away
            fg(r,c) = com_hit;
        else
            fg(r,c) = wrong_guess;
        end

        %let the computer guess by running computer guess
        [fg, score] = com_guess(fg, p_ships, score);

        %check if the computer and player's ships have been sunk and
        %update scores
        [new_c_sunk, c_ships_to_skip] = check_sunk(c_ships, ...
            fg(:,13:22),c_ships_to_skip);
        [new_p_sunk, p_ships_to_skip] = check_sunk(c_ships, ...
            fg(:,1:10),p_ships_to_skip);

        if new_p_sunk == 1
            score = score - 3;
            p_sunk = p_sunk + new_p_sunk;
        end

        if new_c_sunk == 1
            score = score + 3;
            c_sunk = c_sunk + new_c_sunk;
        end

        %update the screen
        drawScene(scene, bg,fg)

        %and display guesses remaining and score
        guesses = guesses - 1;
        guesses_value.String = num2str(guesses);
        score_value.String = num2str(score);

        %let player know who won
        if c_sunk == 5
            fg(:,1:10) = blank;
            bg(:,1:10) = blank;
            drawScene(scene,bg,fg)

            winner = text(800,900,"You win! Hit space to play again.", ...
                "FontSize",20);
            fleet_completely_sunk = true;

            scene = reset_game(scene, fg, bg, winner, score_label, ...
                score_value, guesses_label, guesses_value);

        end
        if p_sunk == 5
            fg(:,13:22) = blank;
            bg(:,13:22) = blank;
            drawScene(scene, bg,fg);

            winner = text(1600,900,"You lose..hit space to play again", ...
                "FontSize",20);
            fleet_completely_sunk = true;
            scene = reset_game(scene, fg, bg, winner, score_label, ...
                score_value, guesses_label, guesses_value);


        end

        
    else
        % display a warning if player's guess is illegal
        warning = text(1300,900,"Invalid guess!",fontSize=12);
        pause(1.5)
        warning.Visible = 'off';
    end

    %if the player has run out of turns
    if guesses==0 && ~fleet_completely_sunk
        fg(:,13:22) = blank;
        bg(:,13:22) = blank;
        drawScene(scene, bg,fg);

        winner = text(1600,900,"You lose.. hit space to play again", ...
            "FontSize",20);
        fleet_completely_sunk = true;
        % reset the game so the player can play again
        scene = reset_game(scene, fg, bg, winner, score_label, score_value, ...
            guesses_label, guesses_value);
    end
end
end
