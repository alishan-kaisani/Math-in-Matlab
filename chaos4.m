function chaos4()
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
p1 = 100.*[0;0];
p2 = 100.*[1;0];
p3 = 100.*[1;1];
p4 = 100.*[0;1];
verticies = [p1,p2,p3,p4];

%Create set of random points to check
X = verticies(1,:);
Y = verticies(2,:);

minX = min(X);
minY = min(Y);
maxX = max(X);
maxY = max(Y);

%Create random seed point to begin with
xi = minX + (maxX - minX).*rand(1,1);
yi = minY + (maxY - minY).*rand(1,1);

point = [xi;yi];

figure
pause(0.01);
pint = round(numPoints/10);
for i = 1:numPoints;
    %Choose a random value b/w 1-3 corresponding to a vertex
    temp = rand(1);
    
    if temp < 1/4
        ind = 1;
    elseif temp < 1/2
        ind = 2;
    elseif temp < 3/4
        ind = 3;
    else 
        ind = 4;
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
    dy = 5.*(vertex(2)-point(2))./8; 
    dx = 5.*(vertex(1)-point(1))./8;      
    colors = {'r', 'g', 'b', 'm'};
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