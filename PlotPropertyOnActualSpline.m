%% Plot one of the column of the table as color on actual spline
DisplayedInfo = 'Planar_Density';

PossibleData = unique(T{:,{DisplayedInfo}});
figure(); %always "figure" before "colormap"
Color=colormap(lines(length(PossibleData)));% generate as many colors as the number of type
for cpt = 1 : length(SortedSpline)-1
    FaceHandle = fill([SortedSpline{cpt}(:,1); flipud(SortedSpline{cpt+1}(:,1))],[SortedSpline{cpt}(:,2); flipud(SortedSpline{cpt+1}(:,2))], 'w','LineWidth', 1);
    %     FaceHandle.FaceColor = [cpt/(length(SortedSpline)-1) cpt/(length(SortedSpline)-1) cpt/(length(SortedSpline)-1)]
    %     FaceHandle.FaceColor = Color(find(T{1:height(T),{'Type'}} == LayerType(cpt)),:);
    FaceHandle.FaceColor = Color(find(T{find(T{:,{'Type'}} == LayerType(cpt)), {DisplayedInfo}} == PossibleData),:);
    hold on;
end
colormap(Color);
grid on;
axis equal;

% chose the info to display: any column of the table
MyTickLabels = cellfun(@num2str, num2cell(PossibleData'), 'UniformOutput', false);
% normalise colormap scale to 1
% PossibleData_scaled = PossibleData + abs(min(PossibleData));
% PossibleData_scaled = PossibleData_scaled./(max(PossibleData_scaled)+1);
PossibleData_scaled = linspace(0,1,length(PossibleData)+1);
% now that's easy
c=colorbar('Ticks',PossibleData_scaled,'TickLabels',[{''}, MyTickLabels]);

switch DisplayedInfo
    case 'Orientation'
        c.Label.String = 'Fiber Orientation (°)';
    case 'Thickness'
        c.Label.String = 'Thickness (mm)';
    case 'Planar_Density'
        c.Label.String = 'Planar Density  (g/m2)';
    case 'Type'
        c.Label.String = 'Type (unitless)';     
end

if SaveFigures
    print(gcf,'-dpng', [cd '\' SaveFiguresPath '\' RunID '\Actual-Planar_Density'],'-r1200');
end

%% Plot one of the column of the table as color on actual spline

DisplayedInfo = 'Thickness';

PossibleData = unique(T{:,{DisplayedInfo}});
figure(); %always "figure" before "colormap"
Color=colormap(lines(length(PossibleData)));% generate as many colors as the number of type
for cpt = 1 : length(SortedSpline)-1
    FaceHandle = fill([SortedSpline{cpt}(:,1); flipud(SortedSpline{cpt+1}(:,1))],[SortedSpline{cpt}(:,2); flipud(SortedSpline{cpt+1}(:,2))], 'w','LineWidth', 1);
    %     FaceHandle.FaceColor = [cpt/(length(SortedSpline)-1) cpt/(length(SortedSpline)-1) cpt/(length(SortedSpline)-1)]
    %     FaceHandle.FaceColor = Color(find(T{1:height(T),{'Type'}} == LayerType(cpt)),:);
    FaceHandle.FaceColor = Color(find(T{find(T{:,{'Type'}} == LayerType(cpt)), {DisplayedInfo}} == PossibleData),:);
    hold on;
end
colormap(Color);
grid on;
axis equal;

% chose the info to display: any column of the table
MyTickLabels = cellfun(@num2str, num2cell(PossibleData'), 'UniformOutput', false);
% normalise colormap scale to 1
% PossibleData_scaled = PossibleData + abs(min(PossibleData));
% PossibleData_scaled = PossibleData_scaled./(max(PossibleData_scaled)+1);
PossibleData_scaled = linspace(0,1,length(PossibleData)+1);
% now that's easy
c=colorbar('Ticks',PossibleData_scaled,'TickLabels',[{''}, MyTickLabels]);

switch DisplayedInfo
    case 'Orientation'
        c.Label.String = 'Fiber Orientation (°)';
    case 'Thickness'
        c.Label.String = 'Thickness (mm)';
    case 'Planar_Density'
        c.Label.String = 'Planar Density  (g/m2)';
    case 'Type'
        c.Label.String = 'Type (unitless)';     
end

if SaveFigures
    print(gcf,'-dpng', [cd '\' SaveFiguresPath '\' RunID '\Actual-Thickness'],'-r1200');
end

%% Plot one of the column of the table as color on actual spline

DisplayedInfo = 'Orientation';

PossibleData = unique(T{:,{DisplayedInfo}});
figure(); %always "figure" before "colormap"
Color=colormap(lines(length(PossibleData)));% generate as many colors as the number of type
for cpt = 1 : length(SortedSpline)-1
    FaceHandle = fill([SortedSpline{cpt}(:,1); flipud(SortedSpline{cpt+1}(:,1))],[SortedSpline{cpt}(:,2); flipud(SortedSpline{cpt+1}(:,2))], 'w','LineWidth', 1);
    %     FaceHandle.FaceColor = [cpt/(length(SortedSpline)-1) cpt/(length(SortedSpline)-1) cpt/(length(SortedSpline)-1)]
    %     FaceHandle.FaceColor = Color(find(T{1:height(T),{'Type'}} == LayerType(cpt)),:);
    FaceHandle.FaceColor = Color(find(T{find(T{:,{'Type'}} == LayerType(cpt)), {DisplayedInfo}} == PossibleData),:);
    hold on;
end
colormap(Color);
grid on;
axis equal;

% chose the info to display: any column of the table
MyTickLabels = cellfun(@num2str, num2cell(PossibleData'), 'UniformOutput', false);
% normalise colormap scale to 1
% PossibleData_scaled = PossibleData + abs(min(PossibleData));
% PossibleData_scaled = PossibleData_scaled./(max(PossibleData_scaled)+1);
PossibleData_scaled = linspace(0,1,length(PossibleData)+1);
% now that's easy
c=colorbar('Ticks',PossibleData_scaled,'TickLabels',[{''}, MyTickLabels]);

switch DisplayedInfo
    case 'Orientation'
        c.Label.String = 'Fiber Orientation (°)';
    case 'Thickness'
        c.Label.String = 'Thickness (mm)';
    case 'Planar_Density'
        c.Label.String = 'Planar Density  (g/m2)';
    case 'Type'
        c.Label.String = 'Type (unitless)';     
end

if SaveFigures
    print(gcf,'-dpng', [cd '\' SaveFiguresPath '\' RunID '\Actual-Orientation'],'-r1200');
end

%% Plot one of the column of the table as color on actual spline

DisplayedInfo = 'Type';

PossibleData = unique(T{:,{DisplayedInfo}});
figure(); %always "figure" before "colormap"
Color=colormap(lines(length(PossibleData)));% generate as many colors as the number of type
for cpt = 1 : length(SortedSpline)-1
    FaceHandle = fill([SortedSpline{cpt}(:,1); flipud(SortedSpline{cpt+1}(:,1))],[SortedSpline{cpt}(:,2); flipud(SortedSpline{cpt+1}(:,2))], 'w','LineWidth', 1);
    %     FaceHandle.FaceColor = [cpt/(length(SortedSpline)-1) cpt/(length(SortedSpline)-1) cpt/(length(SortedSpline)-1)]
    %     FaceHandle.FaceColor = Color(find(T{1:height(T),{'Type'}} == LayerType(cpt)),:);
    FaceHandle.FaceColor = Color(find(T{find(T{:,{'Type'}} == LayerType(cpt)), {DisplayedInfo}} == PossibleData),:);
    hold on;
end
colormap(Color);
grid on;
axis equal;

% chose the info to display: any column of the table
MyTickLabels = cellfun(@num2str, num2cell(PossibleData'), 'UniformOutput', false);
% normalise colormap scale to 1
% PossibleData_scaled = PossibleData + abs(min(PossibleData));
% PossibleData_scaled = PossibleData_scaled./(max(PossibleData_scaled)+1);
PossibleData_scaled = linspace(0,1,length(PossibleData)+1);
% now that's easy
c=colorbar('Ticks',PossibleData_scaled,'TickLabels',[{''}, MyTickLabels]);

switch DisplayedInfo
    case 'Orientation'
        c.Label.String = 'Fiber Orientation (°)';
    case 'Thickness'
        c.Label.String = 'Thickness (mm)';
    case 'Planar_Density'
        c.Label.String = 'Planar Density  (g/m2)';
    case 'Type'
        c.Label.String = 'Type (unitless)';     
end

if SaveFigures
    print(gcf,'-dpng', [cd '\' SaveFiguresPath '\' RunID '\Actual-Type'],'-r1200');
end