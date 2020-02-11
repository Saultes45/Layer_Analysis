%This code is not optimised and badly commented

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Plotting theoritical layer properties
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Metadata
% Written by    : Nathanaël Esnault
% Verified by   : N/A
% Creation date : 2017-02-18
% Version       : 1.0 (finished on ...)
% Modifications :
% Known bugs    :

%% Functions associated with this code :

%% Possible Improvements

%% Cleaning
Path = 'Analysis_Layer_Thickness';

startletter = 'C';
ret = {};
for i = double(startletter):double('Z')
    if exist(['' i ':\Thesis\MATLAB\' Path], 'dir') == 7 % 7=> name is a folder
        ret{end+1} = [i ':\'];  %#ok<SAGROW>
    end
end
cd([ret{end} 'Thesis\MATLAB\' Path]);
formatOut = 'yyyy-mm-dd--HH-MM-SS-FFF';
RunID = datestr(now,formatOut);
GetParameters;
addpath(genpath([ret{end} 'Thesis\MATLAB\' Path])); %importing also the functions in other folders

%% Find the date and use it as a clc;
close all;
clear;

load('long-time_theta.mat');% import the R and Theta data from the
%Spline2Mesh Matlab script
formatOut = 'yyyy-mm-dd--HH-MM-SS-FFF';
RunID = datestr(now,formatOut);
GetParameters;

%this test ID
formatOut = 'yyyy-mm-dd--HH-MM-SS-FFF';
RunID = datestr(now,formatOut);
if SaveFigures
    mkdir([cd '\' SaveFiguresPath '\' RunID]);
end

%% Import the Layer Type table
% This is only an example of the table

if exist([cd '\Layer_Type_Table.xlsx'], 'file') == 2 % 2=> name is a file
    % Import the data
    [~, ~, raw] = xlsread([cd '\Layer_Type_Table.xlsx'],'Sheet1','A3:D102');
    
    % Create output variable
    data = reshape([raw{:}],size(raw));
    
    % Check who is empty and terminate them
    EmptyImportedCellIndex = isnan(data);
    data(any(EmptyImportedCellIndex,2),:) = [];
    
    % Create table
    T = table;
    
    % Allocate imported array to column variable names
    T.Planar_Density = data(:,1);
    T.Thickness = data(:,2);
    T.Orientation = data(:,3);
    T.Type = data(:,4);
    
    % Clear temporary variables
    clearvars data raw EmptyImportedCellIndex;
    
else %--> load default table
    
    %|Planar Density |Thickness |Orientation   |Type       |
    %|---------------|----------|--------------|-----------|
    %|[g/m2]         |[mm]      | [°]          |[unitless] |
    %|---------------|----------|--------------|-----------|
    %| 300           | 0.285    | +0           | 0         |
    %| 150           | 0.1425   | +90          | 1         |
    %| 150           | 0.1425   | +45          | 2         |
    %| 150           | 0.1425   | -45          | 3         |
    %|---------------|----------|--------------|-----------|
    
    Index_Table         = {'0';'1';'2';'3'};
    Planar_Density      = [300;150;150;150];
    Thickness           = [0.285;0.1425;0.1425;0.1425];
    Orientation         = [0;90;45;-45];
    Type                = (0:3)';
    
    % Create a table, T, as a container for the workspace variables
    T = table(Planar_Density,Thickness,Orientation,Type,'RowNames',Index_Table);
end

%% Define what is inside the sample

if exist([cd '\LayerType.xlsx'], 'file') == 2 % 2=> name is a file
    % Import the data
    [~, ~, raw] = xlsread([cd '\LayerType.xlsx'],'Sheet1','A2:A101');%->take 100 cells
    
    % Create output variable
    LayerType = reshape([raw{:}],size(raw));
    
    % Check who is empty and terminate them
    EmptyImportedCellIndex = isnan(LayerType);
    LayerType(EmptyImportedCellIndex) = [];
    
    % Clear temporary variables
    clearvars raw EmptyImportedCellIndex;
    
else%--> load default data
    
    LayerType = [0 1 0 2 3 0 2 3 0 3 2 0 1 0 0 1 0 2 3 0 3 2 0 3 2 0 1 0]';
    
end


I = arrayfun(@(cpt) find(T{1:height(T),{'Type'}} == LayerType(cpt)),1:length(LayerType));

%% Calculate the total theoritical thickness of the sample
Total_Thickness = sum(T{I,{'Thickness'}});

%% Plots -- Thickness, Cummulated Thickness, and Planar_Density
figure();
plot(T{I,{'Thickness'}});
grid on;
xlabel('Layer nummer', 'Interpreter','latex');
ylabel('Thickness (mm)', 'Interpreter','latex');
title('Thickness of the different layers', 'Interpreter','latex');
if SaveFigures
    print(gcf,'-dpng', [cd '\' SaveFiguresPath '\' RunID '\Curve-Thickness of the different layers'],'-r1200');
end

figure();
CummulatedThickness = cumsum(T{I,{'Thickness'}});
plot(CummulatedThickness);
grid on;
xlabel('Layer nummer', 'Interpreter','latex');
ylabel('Cummulated Thickness (mm)', 'Interpreter','latex');
title('Cummulated thickness through the different layers', 'Interpreter','latex');

if SaveFigures
    print(gcf,'-dpng', [cd '\' SaveFiguresPath '\' RunID '\Curve-Cummulated thickness through the different layers'],'-r1200');
end



for cpt = 1 : length(CummulatedThickness)
    % create a text annotations
    if  mod(cpt,2)   % Even  number
        [figx, figy] = dsxy2figxy(gca, [cpt cpt], [max(CummulatedThickness)*1.1 CummulatedThickness(cpt)]);%  (now in figure space)
    else
        [figx, figy] = dsxy2figxy(gca, [cpt cpt], [mean(CummulatedThickness)*1.1 CummulatedThickness(cpt)]);%  (now in figure space)
    end
    har = annotation('textarrow',figx,figy);
    set(har,'String',['(' num2str(cpt) ', ' num2str(CummulatedThickness(cpt)) ')'])
end



figure();
plot(T{I,{'Planar_Density'}});
grid on;
xlabel('Layer nummer', 'Interpreter','latex');
ylabel('Planar Density (g/$m^{2}$)', 'Interpreter','latex');
title('Planar density of the different layers', 'Interpreter','latex');

if SaveFigures
    print(gcf,'-dpng', [cd '\' SaveFiguresPath '\' RunID '\Actual-Thickness-Auto'],'-r1200');
end

%% Fill - Fill by layer Number
figure();
Color=colormap(hot(length(SortedSpline)-1));
for cpt = 1 : length(SortedSpline)-1
    FaceHandle = fill([SortedSpline{cpt}(:,1); flipud(SortedSpline{cpt+1}(:,1))],[SortedSpline{cpt}(:,2); flipud(SortedSpline{cpt+1}(:,2))], 'w','LineWidth', 1);
    %     FaceHandle.FaceColor = [cpt/(length(SortedSpline)-1) cpt/(length(SortedSpline)-1) cpt/(length(SortedSpline)-1)]
    FaceHandle.FaceColor = Color(cpt,:);%[cpt/(length(SortedSpline)-1) 127/255 237/255];
    hold on;
end

hold off;
grid on;
axis equal;

%% Show Actual spline before discretisation
figure();
for cpt = 1 : length(SortedSpline)
    plot(SortedSpline{cpt}(:,1),SortedSpline{cpt}(:,2),'+-')
    hold on;
end
grid on;
axis equal;


%% Surface plots with colors
PlotPropertyOnActualSpline;
Mesh2PostProcess2;
