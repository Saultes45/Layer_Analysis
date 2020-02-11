%This code is not optimised and badly commented

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Plot the Thickness to layers
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Metadata
% Written by    : Nathanaël Esnault
% Verified by   : N/A
% Creation date : 2017-03-16
% Version       : 1.0 (finished on ...)
% Modifications :
% Known bugs    :

%% Functions associated with this code :

%% Possible Improvements


%% Code

NumberOfTheta = 3;%excludes the middle one
SpacingBetweenTheta = 10;

figure();
%plot the middle Theta

IndexMiddleTheta = ceil(length(CreatedTheta)/2);
ThicknessOverLayer = diff(R(:,IndexMiddleTheta));



j = 2;
h = zeros(NumberOfTheta*2+2,1);
LegendLabels = {};

h(1) = plot(ThicknessOverLayer,'bs-'); %plot the middle one

h(2) = plot(diff(R_theo(:,1)),'bd--'); %plot the theoritical one
IndexHandle = [1 2];

ChosenColor=colormap(lines(NumberOfTheta));% generate as many colors as the number of type

for cpt_Theta = 1 : NumberOfTheta
    
    if IndexMiddleTheta + SpacingBetweenTheta*(cpt_Theta-1)  < length(CreatedTheta) && IndexMiddleTheta - SpacingBetweenTheta*(cpt_Theta-1) >0
        hold on;
        j = j + 1; 
        h(j) = plot(diff(R(:,IndexMiddleTheta + SpacingBetweenTheta*(cpt_Theta-1))),'s-', 'Color', ChosenColor(cpt_Theta, :));
        
        hold on;
        j = j + 1; 
        h(j) = plot(diff(R(:,IndexMiddleTheta - SpacingBetweenTheta*(cpt_Theta-1))),'s-.', 'Color', ChosenColor(cpt_Theta, :));
 
        LegendLabels = [LegendLabels {['Slice at +/-' num2str((CreatedTheta(cpt_Theta*SpacingBetweenTheta+IndexMiddleTheta)-CreatedTheta(IndexMiddleTheta))*180/pi) '°']}]; %#ok<AGROW>
        IndexHandle = [IndexHandle (cpt_Theta-1)*2+1+2];
    end
    
end
LegendLabels = [{'Middle','Theo'} LegendLabels];
% legend(h(IndexHandle)', LegendLabels);%, 'Location','best');
legend(h([1 2]), LegendLabels(1:2));
clear j h ChosenColor LegendLabels;
grid on;
xlabel('Layer nummer', 'Interpreter','latex');
ylabel('Thickness (mm)', 'Interpreter','latex');
title('Thickness through the different layers', 'Interpreter','latex');

if SaveFigures
    print(gcf,'-dpng', [cd '\' SaveFiguresPath '\' RunID '\Curve-Thickness through the different layers for given theta'],'-r1200');
end