function chaos()
close all
clear
clc

prompt = {'Enter in the number of points to be used: '};
dlg_title = 'NumPoints User Input';
num_lines = 1;
defaultans = {'5000'};
x = inputdlg(prompt, dlg_title, num_lines, defaultans);
numPoints = [str2num(x{:})];

if (isempty(numPoints)) 
    mydialog('No input given or incorrect type. Please enter 1 int only (>10^4 + for best results)');
    return;
else
    if (length(numPoints) ~= 1)
        mydialog('Too many inputs. Please enter 1 int only (>10^4 + for best results)');
        return;
    end
end

close all

prompt = {'Animate? (Y/N): '};
dlg_title = 'Animation User Input';
num_lines = 1;
defaultans = {'yes'};
x = inputdlg(prompt, dlg_title, num_lines, defaultans);

[~, rem] = strtok(x, ' ,');
if (~isempty(rem{:}))
    mydialog('Too many inputs. Please only enter "yes" or "no"');
    return;    
end

animate = false;
if strcmpi(x{1}, 'yes') || strcmpi(x{1},'y') 
    animate = true;
elseif strcmpi(x{1}, 'no') || strcmpi(x{1},'n')
    animate = false;
else
    mydialog('Invalid Input. Please only enter "yes" or "no"');
end

close all

%Define veritices of triangle (length 1 equilateral with left corner at
%origin)
left = 100.*[0;0];
right = 100.*[1;0];
top = 100.*[0.5;sqrt(3)./2];
verticies = [left,right,top];

%Create set of random points to check
X = verticies(1,:);
Y = verticies(2,:);

minX = min(X);
minY = min(Y);
maxX = max(X);
maxY = max(Y);

%Assume ~50% points wonn't make it so test double number of random points
%to create desired number of plotted points
xi = minX + (maxX - minX).*rand(1,1);
yi = minY + (maxY - minY).*rand(1,1);

point = [xi;yi];

figure
pause(0.01);
pint = round(numPoints/10);
for i = 1:numPoints;
    %Choose a random value b/w 1-3 corresponding to a vertex
    temp = rand(1);
    if temp < 1/3
        ind = 1;
    elseif temp < 2/3
        ind = 2;
    else
        ind = 3;
    end
    vertex = verticies(:,ind);
    point = shift(point,vertex, ind, X, Y);
    axis square
    hold on
    if animate
        if mod(i,pint) == 0
            pause(0.0000000001);
        end
    end
end
end

function npoint = shift(point, vertex, ind, X, Y)
    hold on
    dy = (vertex(2)-point(2))./2; 
    dx = (vertex(1)-point(1))./2;      
    colors = {'r', 'g', 'b'};
    npoint = [point(1) + dx; point(2) + dy];
    if inpolygon(npoint(1),npoint(2), X', Y'); 
        plot(npoint(1), npoint(2), [colors{ind}, '.']);
    end
end

function mydialog(message)
    d = dialog('Position',[300 300 250 150],'Name','Error Report');
    string = strvcat(message,'Click the close button when you''re done.');
    
    %txt
    uicontrol('Parent',d,...
               'Style','text',...
               'Position',[20 80 210 40],...
               'String',string);
    %btn
    uicontrol('Parent',d,...
               'Position',[85 20 70 25],...
               'String','Close',...
               'Callback','delete(gcf)');
end