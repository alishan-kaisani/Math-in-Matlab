function serpinski()
%Output nth level serpinski triangle based on input

close all
clear
clc

prompt = {'Enter in the number of iterations desired (very difficult to see after 6 iterations): '};
dlg_title = 'Iterations User Input';
num_lines = 1;
defaultans = {'3'};
x = inputdlg(prompt, dlg_title, num_lines, defaultans);
level = [str2num(x{:})];

if (isempty(level)) 
    mydialog('No input given or incorrect type. Please enter 1 int only');
    return;
else
    if (length(level) ~= 1)
        mydialog('Too many inputs. Please enter 1 int only');
        return;
    end
end

close all

%Create overall triangle
left = [0;0];
right = [1;0];
top = [0.5;sqrt(3)./2];

initial = [left,right,top];

fill(initial(1,:), initial(2,:), 'black');
pause(1)
hold on

points = initial;
tris = {points};

for i = 1:level
    holding_cell = {};
    for j = 1:length(tris)
        temp = top_break(tris{j}, i);
        holding_cell = [holding_cell, temp];
    end
    pause(1)
    axis square
    tris = holding_cell;
end;

end

function tris = top_break(points, level)
%Helper Function to break down triangle into more pieces

left = points(:,1);
right = points(:,2);
top = points(:,3);

% %Determine half distance of triangle
half_dist = (right(1) - left(1))/2;
% half_dist = 1;

%Create coordinates for halfway points along each line in triangle
nleft = [left(1) + half_dist.*cosd(60);left(2) + half_dist.*sind(60)];
nright = [right(1) + half_dist.*cosd(120); right(2) + half_dist.*sind(120)];
nbottom = [left(1) + half_dist.*cosd(0); left(2) + half_dist.*sind(0)];

tri1 = [left, nbottom, nleft];
tri2 = [nleft, nright, nbottom];
tri3 = [nbottom, right, nright];
tri4 = [nleft, nright, top];

tris = {tri1, tri2, tri3, tri4};

colors = {'r', [250,180,65]./255 , 'y', 'g', 'b', 'm'};

num = mod(level, length(colors));
if num == 0;
    num = 1;
end

fill(tri2(1,:),tri2(2,:), colors{num});

tris(2) = [];

end