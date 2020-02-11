%This code is not optimised and badly commented

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Plot the precise mesh with 3D thickness error
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Metadata
% Written by    : Nathanaël Esnault
% Verified by   : N/A
% Creation date : 2017-02-28
% Version       : 1.0 (finished on ...)
% Modifications :
% Known bugs    :

%% Functions associated with this code :

%% Possible Improvements


%% Plot diff
% clc;
% clear all;
close all;

%% -------------------------


% Calculation of thickness error  %  before plot
for cpt_spline = 1 : length(TheoSpline)-1
    for cpt_theta = 1:length(CreatedTheta)
        E = R(cpt_spline+1,cpt_theta) - R(cpt_spline,cpt_theta);
        E_ref = R_theo(cpt_spline+1,cpt_theta) - R_theo(cpt_spline,cpt_theta);
        E_percentage = (E-E_ref)/abs(E_ref)*100;
        Thickness_Error(cpt_spline, cpt_theta) = E_percentage; %#ok<SAGROW>
    end
end

DisplayedInfo = 'Orientation';

PossibleData = unique(T{:,{DisplayedInfo}});


figure();
% Color=colormap(hot(length(SortedSpline)-1));
Color=colormap(lines(length(PossibleData)));% generate as many colors as the number of type
for cpt_spline = 1 : length(TrueSpline)-1
    for cpt_theta = 1: length(CreatedTheta)-1
        
        p1 = [TrueSpline{cpt_spline+1}(cpt_theta,1) 	TrueSpline{cpt_spline+1}(cpt_theta,2) 	0];
        p2 = [TrueSpline{cpt_spline+1}(cpt_theta+1,1) 	TrueSpline{cpt_spline+1}(cpt_theta+1,2) 0];
        p3 = [TrueSpline{cpt_spline}(cpt_theta+1,1) 	TrueSpline{cpt_spline}(cpt_theta+1,2) 	0]; %circular permutation
        p4 = [TrueSpline{cpt_spline}(cpt_theta,1)       TrueSpline{cpt_spline}(cpt_theta,2) 	0];
        
        p1h = [TrueSpline{cpt_spline+1}(cpt_theta,1) 	TrueSpline{cpt_spline+1}(cpt_theta,2) 	Thickness_Error(cpt_spline, cpt_theta)];
        p2h = [TrueSpline{cpt_spline+1}(cpt_theta+1,1) 	TrueSpline{cpt_spline+1}(cpt_theta+1,2) Thickness_Error(cpt_spline, cpt_theta)];
        p3h = [TrueSpline{cpt_spline}(cpt_theta+1,1) 	TrueSpline{cpt_spline}(cpt_theta+1,2) 	Thickness_Error(cpt_spline, cpt_theta)]; %circular permutation
        p4h = [TrueSpline{cpt_spline}(cpt_theta,1)      TrueSpline{cpt_spline}(cpt_theta,2) 	Thickness_Error(cpt_spline, cpt_theta)];
        
        %buid base: 1 2 3 4
        x = [p1(1) p2(1) p3(1) p4(1)];
        y = [p1(2) p2(2) p3(2) p4(2)];
        z = [p1(3) p2(3) p3(3) p4(3)];
        FaceHandle = fill3(x, y, z, Color(1,:));
        FaceHandle.FaceColor = Color(find(T{find(T{:,{'Type'}} == LayerType(cpt_spline)), {DisplayedInfo}} == PossibleData),:);
        FaceHandle.EdgeColor = 'none';% no edge color, except if you want to see only edges on the graph, you choose
        hold on;
        
        %buid top: 1h 2h 3h 4h
        x = [p1h(1) p2h(1) p3h(1) p4h(1)];
        y = [p1h(2) p2h(2) p3h(2) p4h(2)];
        z = [p1h(3) p2h(3) p3h(3) p4h(3)];
        FaceHandle = fill3(x, y, z, Color(1,:));
        FaceHandle.FaceColor = Color(find(T{find(T{:,{'Type'}} == LayerType(cpt_spline)), {DisplayedInfo}} == PossibleData),:);
        FaceHandle.EdgeColor = 'none';% no edge color, except if you want to see only edges on the graph, you choose
        hold on;
        
        %buid the 4 edges: 1 1h 2h 2 | 2 2h 3h 3 | 3 3h 4h 4 | 4 4h 1h 1
        x = [p1(1) p1h(1) p2h(1) p2(1)];
        y = [p1(2) p1h(2) p2h(2) p2(2)];
        z = [p1(3) p1h(3) p2h(3) p2(3)];
        FaceHandle = fill3(x, y, z, Color(1,:));
        FaceHandle.FaceColor = Color(find(T{find(T{:,{'Type'}} == LayerType(cpt_spline)), {DisplayedInfo}} == PossibleData),:);
        FaceHandle.EdgeColor = 'none';% no edge color, except if you want to see only edges on the graph, you choose
        hold on;
        
        x = [p2(1) p2h(1) p3h(1) p3(1)];
        y = [p2(2) p2h(2) p3h(2) p3(2)];
        z = [p2(3) p2h(3) p3h(3) p3(3)];
        FaceHandle = fill3(x, y, z, Color(1,:));
        FaceHandle.FaceColor = Color(find(T{find(T{:,{'Type'}} == LayerType(cpt_spline)), {DisplayedInfo}} == PossibleData),:);
        FaceHandle.EdgeColor = 'none';% no edge color, except if you want to see only edges on the graph, you choose
        hold on;
        
        x = [p3(1) p3h(1) p4h(1) p4(1)];
        y = [p3(2) p3h(2) p4h(2) p4(2)];
        z = [p3(3) p3h(3) p4h(3) p4(3)];
        FaceHandle = fill3(x, y, z, Color(1,:));
        FaceHandle.FaceColor = Color(find(T{find(T{:,{'Type'}} == LayerType(cpt_spline)), {DisplayedInfo}} == PossibleData),:);
        FaceHandle.EdgeColor = 'none';% no edge color, except if you want to see only edges on the graph, you choose
        hold on;
        
        x = [p4(1) p4h(1) p1h(1) p1(1)];
        y = [p4(2) p4h(2) p1h(2) p1(2)];
        z = [p4(3) p4h(3) p1h(3) p1(3)];
        FaceHandle = fill3(x, y, z, Color(1,:));
        FaceHandle.FaceColor = Color(find(T{find(T{:,{'Type'}} == LayerType(cpt_spline)), {DisplayedInfo}} == PossibleData),:);
        FaceHandle.EdgeColor = 'none';% no edge color, except if you want to see only edges on the graph, you choose
        hold on;
        
    end
end

for cpt = 1 : length(SortedSpline)-1
    FaceHandle = fill([SortedSpline{cpt}(:,1); flipud(SortedSpline{cpt+1}(:,1))],[SortedSpline{cpt}(:,2); flipud(SortedSpline{cpt+1}(:,2))], 'w','LineWidth', 1);
    %     FaceHandle.FaceColor = [cpt/(length(SortedSpline)-1) cpt/(length(SortedSpline)-1) cpt/(length(SortedSpline)-1)]
    FaceHandle.FaceColor = 'none';%[cpt/(length(SortedSpline)-1) 127/255 237/255];
    hold on;
end

hold off;
grid on;
axis square;

% chose the info to display: any column of the table
MyTickLabels = cellfun(@num2str, num2cell(PossibleData'), 'UniformOutput', false);
% normalise colormap scale to 1
% PossibleData_scaled = PossibleData + abs(min(PossibleData));
% PossibleData_scaled = PossibleData_scaled./(max(PossibleData_scaled)+1);
PossibleData_scaled = linspace(0,1,length(PossibleData)+1);
% now that's easy
c=colorbar('Ticks',PossibleData_scaled,'TickLabels',[{''}, MyTickLabels]);


c.Label.String = 'Fiber Orientation (°)';

c.Label.String = 'Average Layer Thickness Error (%)';
xlabel('X dimmention (mm)', 'Interpreter','latex');
ylabel('Y dimmention (mm)', 'Interpreter','latex');
zlabel('Layer Thickness Error Percentage (\%)', 'Interpreter','latex');
title('Layer Thickness Error Percentage of the different layers', 'Interpreter','latex');

if SaveFigures
    print(gcf,'-dpng', [cd '\' SaveFiguresPath '\' RunID '\Actual- 3D -Layer Thickness Error Percentage'],'-r1200');
end