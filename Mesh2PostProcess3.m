%This code is not optimised and badly commented

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Plot the precise mesh with thickness error
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Metadata
% Written by    : Nathanaël Esnault
% Verified by   : N/A
% Creation date : 2017-02-16
% Version       : 1.0 (finished on ...)
% Modifications :
% Known bugs    :

%% Functions associated with this code :

%% Possible Improvements


%% Plot diff

%calculation of thickness error before plot
for cpt_spline = 1 : length(TheoSpline)-1
    for cpt_theta = 1:length(CreatedTheta)-1
        Thickness_Error(cpt_spline, cpt_theta) = ((R(cpt_spline+1,cpt_theta) - R(cpt_spline,cpt_theta)) - (R_theo(cpt_spline+1,cpt_theta) - R_theo(cpt_spline,cpt_theta)));
    end
end

%% Plot absolute (mm) Thickness_Error with Theo spline contour
figure();
flag_top_boundary  = 0;
flag_bottom_boundary = 0;

if ~ColorMapAbsoluteFixed % create a colormap specific for this plot
    PossibleData = unique(Thickness_Error);
else % use a predifined colormap
    PossibleData = linspace(ColorMapAbsoluteMin, ColorMapAbsoluteMax, ColorMapAbsoluteValuesNumber);
end

Color=colormap(parula(length(PossibleData)));% generate as many colors as the number of type
for cpt_spline = 1 : length(TheoSpline)-1
    for cpt_theta = 1:length(CreatedTheta)-1
        %X
        temp_X = [[TheoSpline{cpt_spline+1}(cpt_theta,1); TheoSpline{cpt_spline+1}(cpt_theta+1,1)]; flipud([TheoSpline{cpt_spline}(cpt_theta,1); TheoSpline{cpt_spline}(cpt_theta+1,1)])];
        %Y
        temp_Y = [[TheoSpline{cpt_spline+1}(cpt_theta,2); TheoSpline{cpt_spline+1}(cpt_theta+1,2)]; flipud([TheoSpline{cpt_spline}(cpt_theta,2); TheoSpline{cpt_spline}(cpt_theta+1,2)])];
        
        FaceHandle = fill(temp_X,temp_Y, 'w','LineWidth', 1);
        
        if ~ColorMapAbsoluteFixed % find the exact color for the value
            FaceHandle.FaceColor = Color(find(Thickness_Error(cpt_spline, cpt_theta)==PossibleData),:); %#ok<FNDSB>
        else % find the interval in which the current error is situated
            temp = MyFindInInterval(Thickness_Error(cpt_spline, cpt_theta),PossibleData);
            if sign(temp) == 1
                FaceHandle.FaceColor = Color(temp,:);
            elseif temp == -1 %("value" is outside lower boundary)
                FaceHandle.FaceColor = Color(1,:); % works because we made sure of sorted values, see either unique or linspace
                flag_bottom_boundary = 1;
            elseif temp == -2 %("value" is outside upper boundary)
                FaceHandle.FaceColor = Color(end,:); % works because we made sure of sorted values, see either unique or linspace
                flag_top_boundary = 1;
            end
            clear temp;
        end
        FaceHandle.EdgeColor = 'none';% no edge color, except if you want to see only edges on the graph, you choose
        hold on;
    end
end
grid on;
axis equal;
colormap(Color);

ScaledData = linspace(min(PossibleData),max(PossibleData),10);
MyTickLabels = cellfun(@num2str, num2cell(ScaledData'), 'UniformOutput', false);
if flag_top_boundary %(one of "value" is outside lower boundary)
    MyTickLabels{1} = ['<' MyTickLabels{1}];
end
if flag_bottom_boundary %(one of "value" is outside upper boundary)
    MyTickLabels{end} = ['>' MyTickLabels{end}];
end
clear flag_top_boundary flag_bottom_boundary;
clear temp;
PossibleData_scaled = linspace(0,1,length(PossibleData)+1);
colorbar('Ticks',linspace(0,1,10),'TickLabels',MyTickLabels);
title('Layer Thickness Error (mm)', 'Interpreter', 'latex');

if SaveFigures
    print(gcf,'-dpng', [cd '\' SaveFiguresPath '\' RunID '\Thickness deviation t-t_nom [mm]'],'-r300');
end

%% Plot absolute (mm) Thickness_Error with True spline contour
figure();
flag_top_boundary  = 0;
flag_bottom_boundary = 0;

for cpt_spline = 1 : length(TrueSpline)-1
    for cpt_theta = 1:length(CreatedTheta)-1
        %X
        temp_X = [[TrueSpline{cpt_spline+1}(cpt_theta,1); TrueSpline{cpt_spline+1}(cpt_theta+1,1)]; flipud([TrueSpline{cpt_spline}(cpt_theta,1); TrueSpline{cpt_spline}(cpt_theta+1,1)])];
        %Y
        temp_Y = [[TrueSpline{cpt_spline+1}(cpt_theta,2); TrueSpline{cpt_spline+1}(cpt_theta+1,2)]; flipud([TrueSpline{cpt_spline}(cpt_theta,2); TrueSpline{cpt_spline}(cpt_theta+1,2)])];
        
        FaceHandle = fill(temp_X,temp_Y, 'w','LineWidth', 1);
        if ~ColorMapAbsoluteFixed % find the exact color for the value
            FaceHandle.FaceColor = Color(find(Thickness_Error(cpt_spline, cpt_theta)==PossibleData),:); %#ok<FNDSB>
        else % find the interval in which the current error is situated
            temp = MyFindInInterval(Thickness_Error(cpt_spline, cpt_theta),PossibleData);
            if sign(temp) == 1
                FaceHandle.FaceColor = Color(temp,:);
            elseif temp == -1 %("value" is outside lower boundary)
                FaceHandle.FaceColor = Color(1,:); % works because we made sure of sorted values, see either unique or linspace
                flag_bottom_boundary = 1;
            elseif temp == -2 %("value" is outside upper boundary)
                FaceHandle.FaceColor = Color(end,:); % works because we made sure of sorted values, see either unique or linspace
                flag_top_boundary = 1;
            end
            clear temp;
            
        end
        FaceHandle.EdgeColor = 'none';% no edge color, except if you want to see only edges on the graph, you choose
        hold on;
    end
end
grid on;
axis equal;
colormap(Color);

ScaledData = linspace(min(PossibleData),max(PossibleData),10);
MyTickLabels = cellfun(@num2str, num2cell(ScaledData'), 'UniformOutput', false);
if flag_top_boundary %(one of "value" is outside lower boundary)
    MyTickLabels{1} = ['<' MyTickLabels{1}];
end
if flag_bottom_boundary %(one of "value" is outside upper boundary)
    MyTickLabels{end} = ['>' MyTickLabels{end}];
end
clear flag_top_boundary flag_bottom_boundary;
clear temp;
PossibleData_scaled = linspace(0,1,length(PossibleData)+1);
colorbar('Ticks',linspace(0,1,10),'TickLabels',MyTickLabels);
title('Layer Thickness Error (mm)', 'Interpreter', 'latex');


if SaveFigures
    print(gcf,'-dpng', [cd '\' SaveFiguresPath '\' RunID '\Actual-Average Layer Thickness Error'],'-r1200');
end

%% Calculation of thickness error  %  before plot
for cpt_spline = 1 : length(TheoSpline)-1
    for cpt_theta = 1:length(CreatedTheta)-1
        E = (R(cpt_spline+1,cpt_theta) - R(cpt_spline,cpt_theta));
        E_ref = (R_theo(cpt_spline+1,cpt_theta) - R_theo(cpt_spline,cpt_theta));
        E_percentage = (E-E_ref)/abs(E_ref)*100;
        Thickness_Error(cpt_spline, cpt_theta) = E_percentage;
    end
end



%% Plot relative (%) Thickness_Error with True spline contour
figure();
flag_top_boundary  = 0;
flag_bottom_boundary = 0;

if ~ColorMapRelativeFixed % create a colormap specific for this plot
    PossibleData = unique(Thickness_Error);
else % use a predifined colormap
    PossibleData = linspace(ColorMapRelativeMin, ColorMapRelativeMax, ColorMapRelativeValuesNumber);
end

Color=colormap(parula(length(PossibleData)));% generate as many colors as the number of type
for cpt_spline = 1 : length(TrueSpline)-1
    for cpt_theta = 1:length(CreatedTheta)-1
        %X
        temp_X = [[TrueSpline{cpt_spline+1}(cpt_theta,1); TrueSpline{cpt_spline+1}(cpt_theta+1,1)]; flipud([TrueSpline{cpt_spline}(cpt_theta,1); TrueSpline{cpt_spline}(cpt_theta+1,1)])];
        %Y
        temp_Y = [[TrueSpline{cpt_spline+1}(cpt_theta,2); TrueSpline{cpt_spline+1}(cpt_theta+1,2)]; flipud([TrueSpline{cpt_spline}(cpt_theta,2); TrueSpline{cpt_spline}(cpt_theta+1,2)])];
        
        FaceHandle = fill(temp_X,temp_Y, 'w','LineWidth', 1);
        if ~ColorMapAbsoluteFixed % find the exact color for the value
            FaceHandle.FaceColor = Color(find(Thickness_Error(cpt_spline, cpt_theta)==PossibleData),:); %#ok<FNDSB>
        else % find the interval in which the current error is situated
            temp = MyFindInInterval(Thickness_Error(cpt_spline, cpt_theta),PossibleData);
            if sign(temp) == 1
                FaceHandle.FaceColor = Color(temp,:);
            elseif temp == -1 %("value" is outside lower boundary)
                FaceHandle.FaceColor = Color(1,:); % works because we made sure of sorted values, see either unique or linspace
                flag_bottom_boundary = 1;
            elseif temp == -2 %("value" is outside upper boundary)
                FaceHandle.FaceColor = Color(end,:); % works because we made sure of sorted values, see either unique or linspace
                flag_top_boundary = 1;
            end
            clear temp;
        end
        FaceHandle.EdgeColor = 'none';% no edge color, except if you want to see only edges on the graph, you choose
        hold on;
    end
end
grid on;
axis equal;
colormap(Color);

ScaledData = linspace(min(PossibleData),max(PossibleData),10);
MyTickLabels = cellfun(@num2str, num2cell(ScaledData'), 'UniformOutput', false);
if flag_top_boundary %(one of "value" is outside lower boundary)
    MyTickLabels{1} = ['<' MyTickLabels{1}];
end
if flag_bottom_boundary %(one of "value" is outside upper boundary)
    MyTickLabels{end} = ['>' MyTickLabels{end}];
end
clear flag_top_boundary flag_bottom_boundary;

PossibleData_scaled = linspace(0,1,length(PossibleData)+1);
colorbar('Ticks',linspace(0,1,10),'TickLabels',MyTickLabels);
title('Layer Thickness Error (\%)', 'Interpreter', 'latex');

if SaveFigures
    print(gcf,'-dpng', [cd '\' SaveFiguresPath '\' RunID '\Thickness deviation [%]'],'-r300');
end