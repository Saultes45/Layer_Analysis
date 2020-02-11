%This code is not optimised and badly commented

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Scale data that are in dpi to actual mm
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Metadata
% Written by    : Nathanaël Esnault
% Verified by   : N/A
% Creation date : 2017-02-20
% Version       : 1.0 (finished on ...)
% Modifications :
% Known bugs    :

%% Functions associated with this code :

%% Possible Improvements

%% Find the greatest distance between the first and end curve
Distancec = zeros(length(SortedSpline{1}),1);
minIndexOnEndCurve = zeros(length(SortedSpline{1}),1);
for cpt = 1: length(SortedSpline{1})
    [Distancec(cpt),minIndexOnEndCurve(cpt)] = min(sqrt((SortedSpline{1}(cpt,1)-SortedSpline{end}(:,1)).^2 + ((SortedSpline{1}(cpt,2)-SortedSpline{end}(:,2)).^2)));
end


%% Taking the max of the distance and plotting the line
[M,I] = max(Distancec);

%% Scaling
% TrueDimR = zeros(size(R,1),size(R,2));
TrueDimR = R ./(M)*True_Tichness_mm;
for cpt = 1 : length(SortedSpline)
    TrueDimSpline{cpt} = SortedSpline{cpt}/(M)*True_Tichness_mm;
end

%% Plot - Maximum
% Plot the 2 extreme spline and the line between the 2 extrema
figure();  
plot(SortedSpline{1}(:,1),SortedSpline{1}(:,2));
hold on;
plot(SortedSpline{end}(:,1),SortedSpline{end}(:,2));
hold on;
plot([SortedSpline{1}(I,1) SortedSpline{end}(minIndexOnEndCurve(I),1)],...
    [SortedSpline{1}(I,2) SortedSpline{end}(minIndexOnEndCurve(I),2)],'ko-');
axis equal;
grid on;
xlabel('X dimmentions (dpi)', 'Interpreter','latex');
ylabel('Y dimmentions  (dpi)', 'Interpreter','latex');
title(['Finding the extrema to scale, max = ' num2str(M) ' dpi'], 'Interpreter','latex');


%% Plot - Before scaling
figure();

subplot(2,1,1);
plot(SortedSpline{1}(:,1),SortedSpline{1}(:,2));
hold on;
plot(SortedSpline{end}(:,1),SortedSpline{end}(:,2));
for cpt = 2 : length(SortedSpline)
    hold on;
    plot(SortedSpline{cpt}(:,1),SortedSpline{cpt}(:,2));
end
hold off;
axis equal;
grid on;
xlabel('X dimmentions (dpi)', 'Interpreter','latex');
ylabel('Y dimmentions  (dpi)', 'Interpreter','latex');
title('Unscaled dimentions', 'Interpreter','latex');

%% Plot - After scaling

subplot(2,1,2);
plot(TrueDimSpline{1}(:,1),TrueDimSpline{1}(:,2));
hold on;
plot(TrueDimSpline{end}(:,1),TrueDimSpline{end}(:,2));
for cpt = 2 : length(TrueDimSpline)
    hold on;
    plot(TrueDimSpline{cpt}(:,1),TrueDimSpline{cpt}(:,2));
end
hold off;
axis equal;
grid on;
xlabel('X dimmentions (mm)', 'Interpreter','latex');
ylabel('Y dimmentions  (mm)', 'Interpreter','latex');
title('Scaled dimentions', 'Interpreter','latex');

%% Plot - Check the scaling

Distancec = zeros(length(TrueDimSpline{1}),1);
minIndexOnEndCurve = zeros(length(TrueDimSpline{1}),1);
for cpt = 1: length(TrueDimSpline{1})
    [Distancec(cpt),minIndexOnEndCurve(cpt)] = min(sqrt((TrueDimSpline{1}(cpt,1)-TrueDimSpline{end}(:,1)).^2 + ((TrueDimSpline{1}(cpt,2)-TrueDimSpline{end}(:,2)).^2)));
end
% Taking the max of the distance and plotting the line
[M,I] = max(Distancec);
% Plot the 2 extreme spline and the line between the 2 extrema
figure();  
plot(TrueDimSpline{1}(:,1),TrueDimSpline{1}(:,2));
hold on;
plot(TrueDimSpline{end}(:,1),TrueDimSpline{end}(:,2));
hold on;
plot([TrueDimSpline{1}(I,1) TrueDimSpline{end}(minIndexOnEndCurve(I),1)],...
    [TrueDimSpline{1}(I,2) TrueDimSpline{end}(minIndexOnEndCurve(I),2)],'ko-');
axis equal;
grid on;
xlabel('X dimmentions (mm)', 'Interpreter','latex');
ylabel('Y dimmentions  (mm)', 'Interpreter','latex');
title(['Finding the extrema to scale, max = ' num2str(M) ' mm'], 'Interpreter','latex');

%% Replace old splines and R by new scaled one (not optimum)
SortedSpline = TrueDimSpline;
R = TrueDimR;