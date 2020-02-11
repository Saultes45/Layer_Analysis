%This code is not optimised and badly commented

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Analyse the wrinkels
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Metadata
% Written by    : Nathanaël Esnault
% Verified by   : N/A
% Creation date : 2017-03-02
% Version       : 1.0 (finished on ...)
% Modifications :
% Known bugs    :

%% Functions associated with this code :

%% Possible Improvements

%->saved but not visible
% % if ~ShowGraphAcc
% %     set(Handle_fig1,'Visible','Off');
% % end

%->arial writing on xlabel, ylabel, title and colormap
% % xlabel(['Fiber Orientation (' char(176) ')'], 'Interpreter', 'latex', 'FontName', 'Arial')
% % 176---> double for ° character

%% -------------------------
% For Each Layer, plot the true and actual radii
% As in both  R,Theta space and carthesian coordinates
% Prepare for ~28 figures

for cpt = 1 : length(SortedSpline)
    figure();
    subplot(3,1,1);
    %Plot in R,Theta space
    plot(CreatedTheta*180/pi, flipud(R(cpt,:)));
    hold on;
    plot(CreatedTheta*180/pi, ones(1,length(R(cpt,:)))*R(cpt,end));
    grid on;
    xlabel('Created Theta ($^\circ{}$)', 'Interpreter','latex');
    ylabel('Radius (mm)', 'Interpreter','latex');
    title('Radius', 'Interpreter','latex');
    legend('Actual', 'Theoritical','Location','best');
    
    % % % %     %remove linear trend
    % % % %     p = polyfit(CreatedTheta*180/pi,R(cpt,:),1);
    % % % %     subplot(3,1,2);
    % % % %     %Plot in R,Theta space
    % % % %     plot(CreatedTheta*180/pi, R(cpt,:)-polyval(p,CreatedTheta*180/pi));
    % % % %     hold on;
    % % % %     plot(CreatedTheta*180/pi, R_theo(cpt,:));
    % % % %     grid on;
    % % % %     xlabel('Created Theta ($^\circ{}$)', 'Interpreter','latex');
    % % % %     ylabel('Radius (mm)', 'Interpreter','latex');
    % % % %     title('Radius', 'Interpreter','latex');
    subplot(3,1,2);
    %Plot in carthesian space
    plot(TrueSpline{cpt}(:,1), TrueSpline{cpt}(:,2));
    hold on;
    plot(TheoSpline{cpt}(:,1), TheoSpline{cpt}(:,2));
    grid on;
    xlabel('X dimmention (mm)', 'Interpreter','latex');
    ylabel('Y dimmention (mm)', 'Interpreter','latex');
    title('Radius', 'Interpreter','latex');
    legend('Actual', 'Theoritical','Location','best');
%     [U,V] = gradient(flipud(R(cpt,:))-mean(R(cpt,:)));
%     hold on
%     quiver(TrueSpline{cpt}(:,1),TrueSpline{cpt}(:,2),U,V)
%     hold off
    
    subplot(3,1,3);
    %Plot difference in in R,Theta space
    plot(CreatedTheta*180/pi, flipud(R(cpt,:))-R(cpt,end));
    hold on;
    xlabel('Created Theta ($^\circ{}$)', 'Interpreter','latex');
    ylabel('Radius (mm)', 'Interpreter','latex');
    title('Radius', 'Interpreter','latex');
    grid on;    
end


%% Detect wrinkles height, length and area