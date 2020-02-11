%This code is not optimised and badly commented

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Convert spline to mesh (prepare a coffee, its will be long...)
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


%% Find the date and use it as a clc;
close all;
clear;
%this test ID
formatOut = 'yyyy-mm-dd--HH-MM-SS-FFF';
RunID = datestr(now,formatOut);

%% Code

%listing des fichiers et dossiers dans le chemin donné
MyDirInfo = dir([cd '\*.mat']);

if ~isempty(MyDirInfo)  %repertory exists + file exists
    liste_fichier_log = [];
    
    
cpt_spline = 1;    
    for cpt_file_or_folder = 1 : size(MyDirInfo,1)
        if ~isempty(strfind(MyDirInfo(cpt_file_or_folder).name, 'Image_'));
            load(MyDirInfo(cpt_file_or_folder).name);
            spline{cpt_spline}=zeros(length(splinevalx),2);
            spline{cpt_spline}(:,1) = splinevalx;
            spline{cpt_spline}(:,2) = splinevaly;
            clear splinevalx splinevaly;
            cpt_spline = cpt_spline + 1;
        end
    end
end

clear MyDirInfo;

figure();
for cpt = 1 : length(spline)
    plot(spline{cpt}(:,1),spline{cpt}(:,2),'+-')
    hold on;
end
grid on;
axis equal;



for cpt = 1 : length(spline)
    si(cpt) = size(spline{cpt},1);
end
figure();
plot(si,'+-');
[~,I] = sort(si);

%% Sorting the spline
for cpt = 1 : length(spline)
    SortedSpline{cpt} = spline{I(cpt)};
end

clear spline;

figure();
for cpt = 1 : length(SortedSpline)
    plot(SortedSpline{cpt}(:,1),SortedSpline{cpt}(:,2),'+-')
    hold on;
end
grid on;
axis equal;

for cpt = 1 : length(SortedSpline)
    si(cpt) = size(SortedSpline{cpt},1);
end
figure();
plot(si,'+-');


% % % % % % % % % % % % % % % % th = 0:pi/50:pi;
% % % % % % % % % % % % % % % % figure();
% % % % % % % % % % % % % % % % for cpt = 1 : length(SortedSpline)
% % % % % % % % % % % % % % % %     % Try to fit a circle
% % % % % % % % % % % % % % % %     %% Regression circle 1
% % % % % % % % % % % % % % % %     Y1 = SortedSpline{cpt}(:,1);
% % % % % % % % % % % % % % % %     Y2 = SortedSpline{cpt}(:,2);
% % % % % % % % % % % % % % % %     theo = ones(length(Y1),1);
% % % % % % % % % % % % % % % %
% % % % % % % % % % % % % % % %     %% Regression
% % % % % % % % % % % % % % % %     Reg1_K1_0 = Y1.^2+Y2.^2;
% % % % % % % % % % % % % % % %     Reg1_K2_0 = Y1;
% % % % % % % % % % % % % % % %     Reg1_K3_0 = Y2;
% % % % % % % % % % % % % % % %     Reg1_K4_0 = ones(length(Y1),1);
% % % % % % % % % % % % % % % %     Reg1_K0 = [Reg1_K1_0 Reg1_K2_0 Reg1_K3_0 Reg1_K4_0];
% % % % % % % % % % % % % % % %     clear Reg1_K1_0 Reg1_K2_0 Reg1_K3_0 Reg1_K4_0;
% % % % % % % % % % % % % % % %
% % % % % % % % % % % % % % % %     P1 = (Reg1_K0' * Reg1_K0)\Reg1_K0' * theo;
% % % % % % % % % % % % % % % %
% % % % % % % % % % % % % % % %     Residual = theo - Reg1_K0 * P1;
% % % % % % % % % % % % % % % %     ResidualMean = mean(abs(Residual));
% % % % % % % % % % % % % % % %
% % % % % % % % % % % % % % % %     Center_x(cpt) = -0.5*P1(2)/P1(1);
% % % % % % % % % % % % % % % %     Center_y(cpt) = -0.5*P1(3)/P1(1);
% % % % % % % % % % % % % % % %     b_norm = sqrt(P1(2)^2+P1(3)^2);
% % % % % % % % % % % % % % % %     Radius2(cpt) = sqrt(1/(4*P1(1)^2)*(P1(2)^2+P1(3)^2)+(1-P1(4))/P1(1));
% % % % % % % % % % % % % % % %
% % % % % % % % % % % % % % % %     %% Plots
% % % % % % % % % % % % % % % %     plot(Y1,Y2,'rs-')
% % % % % % % % % % % % % % % %     grid on;
% % % % % % % % % % % % % % % %     plot(Center_x(cpt), Center_y(cpt),'sg');
% % % % % % % % % % % % % % % %     hold on
% % % % % % % % % % % % % % % %     xunit = Radius2(cpt) * cos(th) + Center_x(cpt);
% % % % % % % % % % % % % % % %     yunit = Radius2(cpt) * sin(th) + Center_y(cpt);
% % % % % % % % % % % % % % % %     plot(xunit, yunit, 'b*-');
% % % % % % % % % % % % % % % %     hold on;
% % % % % % % % % % % % % % % %     clear Y1 Y2 Reg1_K0 P1
% % % % % % % % % % % % % % % % end

%% unite the starting and ending points of each curve
StartPoints = zeros(length(SortedSpline),2);
EndPoints = zeros(length(SortedSpline),2);
for cpt = 1 : length(SortedSpline)
    StartPoints(cpt,1) = SortedSpline{cpt}(1,1); % X axis
    EndPoints(cpt,1) = SortedSpline{cpt}(end,1); % X axis
    
    StartPoints(cpt,2) = SortedSpline{cpt}(1,2); % Y axis
    EndPoints(cpt,2) = SortedSpline{cpt}(end,2); % Y axis
end

%%Linear regression on the starting and ending lines
%starting
p_start = polyfit(StartPoints(:,1),StartPoints(:,2),1);
%ending
p_end = polyfit(EndPoints(:,1),EndPoints(:,2),1);


%plot the reasult

figure();
for cpt = 1 : length(SortedSpline)
    plot(SortedSpline{cpt}(:,1),SortedSpline{cpt}(:,2),'+-')
    hold on;
end
plot([StartPoints(:,1); 16000], polyval(p_start,[StartPoints(:,1); 16000]));
hold on;
plot([0; EndPoints(:,1)], polyval(p_end,[0; EndPoints(:,1)]));
grid on;
axis equal;

%% find the intersection of the 2 lines, being the center
%line1
% X1 = [StartPoints(end,1); polyval(p_start,StartPoints(end,1))];
% Y1 = [16e3; polyval(p_start,16e3)];
X1 = [StartPoints(end,1); 16e3];
Y1 = [polyval(p_start,StartPoints(end,1)); polyval(p_start,16e3)];
%line2
% X2 = [0; polyval(p_end,0)];
% Y2 = [EndPoints(end,1); polyval(p_end,EndPoints(end,1))];
X2 = [0;  EndPoints(end,1)];
Y2 = [polyval(p_end,0); polyval(p_end,EndPoints(end,1))];

% Draw the 4 points
hold on;
plot(X1(1),Y1(1),'ks');
hold on;
plot(X1(2),Y1(2),'ks');
hold on;
plot(X2(1),Y2(1),'ks');
hold on;
plot(X2(2),Y2(2),'ks');

[X0,Y0] = intersections(X1,Y1,X2,Y2);
hold on;
plot(X0,Y0,'r*');

%% Center the center to (0,0)c
for cpt = 1 : length(SortedSpline)
    SortedSpline{cpt}(:,1) = SortedSpline{cpt}(:,1) - X0;
    SortedSpline{cpt}(:,2) = SortedSpline{cpt}(:,2) - Y0;
end




%% unite the starting and ending points of each curve
StartPoints = zeros(length(SortedSpline),2);
EndPoints = zeros(length(SortedSpline),2);
for cpt = 1 : length(SortedSpline)
    StartPoints(cpt,1) = SortedSpline{cpt}(1,1); % X axis
    EndPoints(cpt,1) = SortedSpline{cpt}(end,1); % X axis
    
    StartPoints(cpt,2) = SortedSpline{cpt}(1,2); % Y axis
    EndPoints(cpt,2) = SortedSpline{cpt}(end,2); % Y axis
end

%% Linear regression#2 on the starting and ending lines
%starting
p_start = polyfit(StartPoints(:,1),StartPoints(:,2),1);
%ending
p_end = polyfit(EndPoints(:,1),EndPoints(:,2),1);


%plot the reasult

figure();
for cpt = 1 : length(SortedSpline)
    plot(SortedSpline{cpt}(:,1),SortedSpline{cpt}(:,2),'+-')
    hold on;
end
plot([StartPoints(:,1); 0], polyval(p_start,[StartPoints(:,1); 0]));
hold on;
plot([0; EndPoints(:,1)], polyval(p_end,[0; EndPoints(:,1)]));
grid on;
axis equal;




figure();
for cpt = 1 : length(SortedSpline)
    plot(SortedSpline{cpt}(:,1),SortedSpline{cpt}(:,2),'+-');
    hold on;
end
hold on;
%plot center
plot(0,0,'k*');

grid on;
axis equal;


%% find the max and min theta
theta_left = pi-abs(atan(polyval(p_start,StartPoints(end,1))/StartPoints(end,1)));
theta_right = atan(polyval(p_end,EndPoints(end,1))/EndPoints(end,1));
DeltaTheta_deg = (theta_left - theta_right)*180/pi;


%% create your discretized Theta <---- These loops takes ages
CreatedTheta = linspace(theta_right, theta_left,1000);
R = zeros(length(SortedSpline),length(CreatedTheta));
for cpt_spline = 1 : length(SortedSpline)
    %     Calculate all the straight lines between the each 2 pts of the considered curve
    R_max = max(sqrt(SortedSpline{cpt_spline}(:,1).^2+SortedSpline{cpt_spline}(:,2).^2));
    WaitBarHandle = waitbar(0,'Finding Intersections...');
    for cpt_theta = 1 : length(CreatedTheta)
        waitbar(cpt_theta/length(CreatedTheta),WaitBarHandle,[num2str(cpt_theta/length(CreatedTheta)*100) ' % completed for spline ' num2str(cpt_spline) '/' num2str(length(SortedSpline))]);
        %step1:for each spline, for each Theta, find the radius
        %--------------------------------------------------------
        if cpt_theta == 1
            R(cpt_spline, cpt_theta) = sqrt(SortedSpline{cpt_spline}(end,1)^2+SortedSpline{cpt_spline}(end,2)^2);
        elseif cpt_theta == length(CreatedTheta)
            R(cpt_spline, cpt_theta) = sqrt(SortedSpline{cpt_spline}(1,1)^2+SortedSpline{cpt_spline}(1,2)^2);
        else
            %step2: same R as previous but with current CreatedTheta
            %--------------------------------------------------------
            tempPT_X =  R_max*cos(CreatedTheta(cpt_theta));
            tempPT_Y =  R_max*sin(CreatedTheta(cpt_theta));
            %step3: find the distances between al  the different points of
            %the curve and the previous tempoary point
            %--------------------------------------------------------
            X0 = []; %init empty for while loop
            Y0 = []; %init empty for while loop
            tempDistance = sqrt((tempPT_X-SortedSpline{cpt_spline}(:,1)).^2 + (tempPT_Y-SortedSpline{cpt_spline}(:,2)).^2);
            [~,I] = min(tempDistance);
            tempDistance2 = tempDistance;
            tempDistance2(I) = [];
            nbrtries = 0;
            while isempty(X0)
                [tempMin,I2] = min(tempDistance2);
                In = find(tempDistance == tempMin);
                tempDistance2(I2) = [];
                %step5: find the intersection with the [closest2ndpt closest
                %point ] and the [0,0 to the tempPT]
                %--------------------------------------------------------
                X1 = [SortedSpline{cpt_spline}(In,1); SortedSpline{cpt_spline}(I,1)];
                Y1 = [SortedSpline{cpt_spline}(In,2); SortedSpline{cpt_spline}(I,2)];
                X2 = [0; tempPT_X];
                Y2 = [0; tempPT_Y];
                [X0,Y0] = intersections(X1,Y1,X2,Y2);
                nbrtries = nbrtries + 1;
            end
            % Draw the 4 points
            % % % %             figure();
            % % % %             plot(tempPT_X,tempPT_Y,'bd');
            % % % %             hold on;
            % % % %             plot(SortedSpline{cpt_spline}(:,1),SortedSpline{cpt_spline}(:,2),'g-o');
            % % % %             hold on;
            % % % %             plot(X1,Y1,'ks-');
            % % % %             hold on;
            % % % %             plot(X2,Y2,'rs-');
            % % % %             hold on;
            % % % %             plot(X0,Y0,'b*');
            % % % %             grid on;
            %step6 find the R
            R(cpt_spline, cpt_theta) = sqrt((X0)^2 + (Y0)^2);
        end
        
    end
    close(WaitBarHandle);
end

%% Scale data
ScaleSplineAndRadius;

%% Save the data
save([cd '\Data\R_Theta_Actual\long-time_theta'],'R','CreatedTheta','SortedSpline');

% % % % % % %% Finding the straight line that descibe the best the different centers
% % % % % % circle_center_coefficients = polyfit(Center_x, Center_y, 1);
% % % % % % hold on;
% % % % % % A_X = [];
% % % % % % A_Y = [];
% % % % % % for cpt = 1 : length(SortedSpline)
% % % % % %     A_X = [A_X; SortedSpline{cpt}(:,1)];
% % % % % %     A_Y = [A_Y; SortedSpline{cpt}(:,2)];
% % % % % % end
% % % % % % [~,I] = max(A_X);
% % % % % %
% % % % % % interp_x = [min(Center_x) A_X(I)];%linspace(min(Center_x),max(Center_x),100);
% % % % % % C = polyval(circle_center_coefficients, interp_x);
% % % % % % % find the
% % % % % % clear A_X A_Y;
% % % % % % plot(interp_x, polyval(circle_center_coefficients, interp_x),'kd-');
% % % % % % grid on;
% % % % % %
% % % % % % legend('Retrived points','Center after LMS','After LMS','Location','best');
% % % % % % title({'\makebox[4in][c]{Circular regression}','\makebox[4in][c]{}'},'Interpreter','latex');
% % % % % % axis equal;

% % % % % % %% Study of the centers of the circular regression
% % % % % % figure();
% % % % % % subplot(2,1,1);
% % % % % % plot(Center_x);
% % % % % % title('CenterX','Interpreter','latex');
% % % % % % grid on;
% % % % % % subplot(2,1,2);
% % % % % % plot(Center_y);
% % % % % % title('CenterY','Interpreter','latex');
% % % % % % grid on;

% % % % % % % figure();
% % % % % % % subplot(2,1,1);
% % % % % % % plot(SortedSpline{1}(:,1),SortedSpline{1}(:,2));
% % % % % % % hold on;
% % % % % % % plot(SortedSpline{end}(:,1),SortedSpline{end}(:,2));
% % % % % % % for cpt = 2 : length(SortedSpline)
% % % % % % %     hold on;
% % % % % % %     plot(SortedSpline{cpt}(:,1),SortedSpline{cpt}(:,2));
% % % % % % %
% % % % % % % end
% % % % % % % hold on;
% % % % % % % stem(SortedSpline{1}(I,1),SortedSpline{1}(I,2));
% % % % % % % grid on;
% % % % % % % xlim([min(SortedSpline{1}(1,1), SortedSpline{end}(1,1)) max(SortedSpline{1}(end,1), SortedSpline{end}(end,1))]);
% % % % % % % subplot(2,1,2);
% % % % % % % plot(SortedSpline{1}(:,1),Distancec);
% % % % % % % hold on;
% % % % % % % plot([SortedSpline{1}(I,1) SortedSpline{1}(I,1)],[min(Distancec) Distancec(I)]);
% % % % % % % grid on;
% % % % % % % xlim([min(SortedSpline{1}(1,1), SortedSpline{end}(1,1)) max(SortedSpline{1}(end,1), SortedSpline{end}(end,1))]);
% % % % % % % axis equal


% % % figure();
% % % plot(tempPT_X,tempPT_Y,'bd');
% % % hold on;
% % % plot(SortedSpline{cpt_spline}(:,1),SortedSpline{cpt_spline}(:,2),'g-o');
% % % hold on;
% % % plot(X1,Y1,'ks-');
% % % hold on;
% % % plot(X2,Y2,'rs-');
% % % hold on;
% % % plot(X0,Y0,'b*');
% % % grid on;