%Memory graphics draft
%Mohammed Maalin 11/10

clc
clear

%using retro_cards to setup a scene
scene = simpleGameEngine('retro_cards.png', 16,16,5,[207,207,207]);
sprites = [1:10; 11:20; 21:30; 31:40; 41:50; 51:60; 61:70; 71:80; 81:90];

back = ones(5,5);
front = ones(5,5);
drawScene(scene, back, front);

title = text(120,180,'Memory','FontSize',30);
subtitle = text(120,220,'Press space to begin!','FontSize',12);

k = getKeyboardInput(scene);
if k == 'space'
    title.Visible = 'off';
    subtitle.Visible = 'off';
end

for i = 1:5
    for j = 1:5
        front(i, j) = (20 + randi(18));
    end
end

back = back*3;

drawScene(scene, back, front);

count = 0;
fails = 0;
while 1
    if fails >= 3
        title.String = 'You lose...';

        x = -300;
        y=200;
        title.Position = [x,y];
        title.Visible = 'on';

        while x ~= 200
            x = x+10;
            title.Position = [x,y];
            pause(0.01);
        end

        break
    end

    [x,y,button] = getMouseInput(scene);
    check_x(count+1) = x;
    check_y(count+1) = y;

    if (back(x,y) ~= 7 || back(x,y) ~= 4)
        back(x,y) = 1;
    end
    count = count + 1;

    if count~=0 && mod(count,2) == 0
        if front(check_x(count),check_y(count)) == front(check_x(count-1), check_y(count-1))
            front(check_x(count), check_y(count)) = 1;
            front(check_x(count-1), check_y(count-1)) = 1;

            back(check_x(count), check_y(count)) = 7;
            back(check_x(count-1), check_y(count-1)) = 7;
        else
            front(check_x(count), check_y(count)) = 1;
            front(check_x(count-1), check_y(count-1)) = 1;

            back(check_x(count), check_y(count)) = 4;
            back(check_x(count-1), check_y(count-1)) = 4;

            fails = fails+1;
        end
    end

    drawScene(scene, back, front);
end