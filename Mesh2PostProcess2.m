%This code is not optimised and badly commented

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Plotting true layer properties
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Metadata
% Written by    : Nathanaël Esnault
% Verified by   : N/A
% Creation date : 2017-02-19
% Version       : 1.0 (finished on ...)
% Modifications :
% Known bugs    :

%% Functions associated with this code :

%% Possible Improvements

%% A fair bit of cleaning
close all

%this test ID
if ~(exist('RunID', 'var') == 1) % 1=> variable in workspace
    formatOut = 'yyyy-mm-dd--HH-MM-SS-FFF';
    RunID = datestr(now,formatOut);
end
GetParameters;

%% Plot the mesh (uses a sh** load of RAM(~3GB), be carfefull)

if PlotMesh
    figure();
    Color=colormap(lines(length(SortedSpline)));% generate as many colors as the number of type
    for cpt_spline = 1 :  length(SortedSpline)
        for cpt_theta = 1 : length(CreatedTheta)
            plot([0 R(cpt_spline,cpt_theta).*cos(CreatedTheta(cpt_theta))],[0 R(cpt_spline,cpt_theta).*sin(CreatedTheta(cpt_theta))],'-s','Color',Color(cpt_spline,:));
            hold on;
        end
    end
    if SaveFigures
        print(gcf,'-dpng', [cd '\' SaveFiguresPath '\' RunID '\Generated Mesh'],'-r1200');
    end
end

%% Plot the R difference for every layer
figure();
for cpt_spline = 1 : length(SortedSpline)-1
    plot(CreatedTheta*180/pi,R(cpt_spline+1, :)-R(cpt_spline, :));
    hold on;
end
hold off;
grid on;
xlabel('Recreated Theta ($^{\circ{}}$)', 'Interpreter','latex');
ylabel('Radius difference (mm)', 'Interpreter','latex');
title('Radius difference of the different layers', 'Interpreter','latex');

if SaveFigures
    print(gcf,'-dpng', [cd '\' SaveFiguresPath '\' RunID '\Radius difference of the different layers'],'-r1200');
end

%% Plot the layer thickness for every layer
MeanLayerThickness = zeros(length(SortedSpline)-1,1);
for cpt_spline = 1 : length(SortedSpline)-1
    MeanLayerThickness(cpt_spline) = mean(R(cpt_spline+1, :)-R(cpt_spline, :));
end
figure();
plot(MeanLayerThickness);
grid on;
xlabel('Layer nummer', 'Interpreter','latex');
ylabel('Average thickness (mm)', 'Interpreter','latex');
title('Average thickness of the different layers', 'Interpreter','latex');
if SaveFigures
    print(gcf,'-dpng', [cd '\' SaveFiguresPath '\' RunID '\Curves-Average thickness of the different layers'],'-r1200');
end

%% Plot the layer thickness for every layer in colors
PossibleData = unique(MeanLayerThickness);
figure();
Color=colormap(jet(length(PossibleData)));% generate as many colors as the number of type
for cpt = 1 : length(SortedSpline)-1
    FaceHandle = fill([SortedSpline{cpt}(:,1); flipud(SortedSpline{cpt+1}(:,1))],[SortedSpline{cpt}(:,2); flipud(SortedSpline{cpt+1}(:,2))], 'w','LineWidth', 1);
    FaceHandle.FaceColor = Color(find(MeanLayerThickness(cpt)==PossibleData),:); %#ok<FNDSB>
    hold on;
end
hold off;
grid on;
axis equal;
colormap(Color);


ScaledData = linspace(min(PossibleData),max(PossibleData),10);
MyTickLabels = cellfun(@num2str, num2cell(ScaledData'), 'UniformOutput', false);
PossibleData_scaled = linspace(0,1,length(PossibleData)+1);
c=colorbar('Ticks',linspace(0,1,10),'TickLabels',MyTickLabels);
c.Label.String = 'Average True Layer Thickness (mm)';

if SaveFigures
    print(gcf,'-dpng', [cd '\' SaveFiguresPath '\' RunID '\Actual-MeanLayerThickness'],'-r1200');
end


%% Plot the layer thickness difference (compared to the theoritical one) for every layer in colors
Thickness_Error = MeanLayerThickness-T{I,{'Thickness'}};
PossibleData = unique(Thickness_Error);
figure();
Color=colormap(hot(length(PossibleData)));% generate as many colors as the number of type
for cpt = 1 : length(SortedSpline)-1
    FaceHandle = fill([SortedSpline{cpt}(:,1); flipud(SortedSpline{cpt+1}(:,1))],[SortedSpline{cpt}(:,2); flipud(SortedSpline{cpt+1}(:,2))], 'w','LineWidth', 1);
    FaceHandle.FaceColor = Color(find(Thickness_Error(cpt)==PossibleData),:); %#ok<FNDSB>
    hold on;
end
grid on;
axis equal;
colormap(Color);


ScaledData = linspace(min(PossibleData),max(PossibleData),10);
MyTickLabels = cellfun(@num2str, num2cell(ScaledData'), 'UniformOutput', false);
PossibleData_scaled = linspace(0,1,length(PossibleData)+1);
c=colorbar('Ticks',linspace(0,1,10),'TickLabels',MyTickLabels);
c.Label.String = 'Average Layer Thickness Error (mm)';

if SaveFigures
    print(gcf,'-dpng', [cd '\' SaveFiguresPath '\' RunID '\Actual-Average Layer Thickness Error1'],'-r1200');
end

%% Generate the mesh that should have been seen: start point R(1,1)
R_theo = zeros(length(SortedSpline),length(CreatedTheta));
R_theo(1,:) = ones(1,length(CreatedTheta))*R(1,1);
for cpt_spline = 2 : length(SortedSpline)
    R_theo(cpt_spline,:) = T{I(cpt_spline-1),{'Thickness'}}+R_theo(cpt_spline-1,1);
end

%display#1
figure();
Color=colormap(lines(length(SortedSpline)));% generate as many colors as the number of type
for cpt_spline = 1 :  length(SortedSpline)
    TheoSpline{cpt_spline}(:,1) = R_theo(cpt_spline,:).*cos(CreatedTheta(:)');
    TheoSpline{cpt_spline}(:,2) = R_theo(cpt_spline,:).*sin(CreatedTheta(:)');
    TrueSpline{cpt_spline}(:,1) = R(cpt_spline,:).*cos(CreatedTheta(:)');
    TrueSpline{cpt_spline}(:,2) = R(cpt_spline,:).*sin(CreatedTheta(:)');
    plot(R_theo(cpt_spline,:).*cos(CreatedTheta(:)'),R_theo(cpt_spline,:).*sin(CreatedTheta(:)'),'-s','Color',Color(cpt_spline,:));
    hold on;
end
grid on;
axis equal;


if SaveFigures
    print(gcf,'-dpng', [cd '\' SaveFiguresPath '\' RunID '\TheoSpline as lines'],'-r1200');
end

%display#2
figure();
for cpt = 1 : length(TheoSpline)-1
    FaceHandle = fill([TheoSpline{cpt}(:,1); flipud(TheoSpline{cpt+1}(:,1))],[TheoSpline{cpt}(:,2); flipud(TheoSpline{cpt+1}(:,2))], 'w','LineWidth', 1);
    FaceHandle.FaceColor = [1 1 1];
    hold on;
end
hold off;
grid on;
axis equal;


if SaveFigures
    print(gcf,'-dpng', [cd '\' SaveFiguresPath '\' RunID '\TheoSpline with white fill'],'-r1200');
end

%% Plot TheoSpline

Thickness_Error = MeanLayerThickness-T{I,{'Thickness'}};
PossibleData = unique(Thickness_Error);
figure();
Color=colormap(hot(length(PossibleData)));% generate as many colors as the number of type
for cpt = 1 : length(TheoSpline)-1
    FaceHandle = fill([TheoSpline{cpt}(:,1); flipud(TheoSpline{cpt+1}(:,1))],[TheoSpline{cpt}(:,2); flipud(TheoSpline{cpt+1}(:,2))], 'w','LineWidth', 1);
    FaceHandle.FaceColor = Color(find(Thickness_Error(cpt)==PossibleData),:); %#ok<FNDSB>
    hold on;
end
grid on;
axis equal;
colormap(Color);

ScaledData = linspace(min(PossibleData),max(PossibleData),10);
MyTickLabels = cellfun(@num2str, num2cell(ScaledData'), 'UniformOutput', false);
PossibleData_scaled = linspace(0,1,length(PossibleData)+1);
c=colorbar('Ticks',linspace(0,1,10),'TickLabels',MyTickLabels);
c.Label.String = 'Average Layer Thickness Error (mm)';

if SaveFigures
    print(gcf,'-dpng', [cd '\' SaveFiguresPath '\' RunID '\Theo-Thickness'],'-r1200');
end

%% Other plots
% WrinkelsAnalysis;
Mesh2PostProcess3;