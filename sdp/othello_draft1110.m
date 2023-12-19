% Software Design Project graphics draft
% Mohammed Maalin 11/10/2023

clc
clear

scene = simpleGameEngine('sprite3.png', 16,16, 4, [206,206,206]);
background = 1 * ones(8,16);

drawScene(scene, background);
title = text(350,250,'Othello', 'FontSize',64);
subtitle = text(420,300,'Press space to play', 'FontSize',12);

key = getKeyboardInput(scene);
if strcmp(key,'space') == 1
    

    title.Visible = 'off';
    subtitle.Visible= 'off';

    empty = 1;
    black = 2;
    white = 3;
    gray = 4;
    cell = 5;
    clock = 6;

    board = empty * ones(8,16);
    board(4,4) = black;
    board(4,5) = white;
    board(5,4) = white;
    board(5,5) = black;


    grid = empty * ones(8,16);
    grid(2,12) = clock;
    grid(1:8,1:8) = cell;

    turn = black;
    grid(4,12) = turn;

    drawScene(scene,grid,board);

    whos_turn = text(770,220,'''s turn',FontSize=16);

    grid(3,4) = gray;
    drawScene(scene,grid,board);

        secs = 0;
        stopwatch = text(770,90,num2str(secs),FontSize=32);

        % A(i, j) = [floor(white_pos / 8), mod(white_pos, 8)]
        white_pos = find(board == 3)
        
        for i = 1:length(white_pos)  
            x = floor(white_pos(i) / 8);
            y = mod(white_pos(i), 8);

            x
            y
            
            if (board(x+1,y)) == empty 
                grid(x+1,y) = gray;
                break;
            elseif (board(x-1,y)) == empty
                     grid(x-1,y) = gray;
                     break;
            elseif board(x+1,y+1) == empty
                    grid(x+1,y+1) = gray;
                    break;
            elseif board(x,y+1) == empty 
                grid(x,y+1) = gray;
                break;
            elseif board(x,y-1) == empty
                grid(x,y-1) = gray;
                break;
            end
        end
        drawScene(scene,grid,board);
        
        while 1
            while 1
            pause(1);
            secs = secs+1;
            stopwatch.Visible = 'off';
            stopwatch.String = num2str(secs);
            stopwatch.Visible = 'on';
            end


        end
end