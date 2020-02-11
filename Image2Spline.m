%This code is not optimised and badly commented

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Main
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
addpath(genpath([ret{end} 'Thesis\MATLAB\' Path])); %importing also the functions in other folders

%% Find the date and use it as a clc;
close all;
clear;
%this test ID
formatOut = 'yyyy-mm-dd--HH-MM-SS-FFF';
RunID = datestr(now,formatOut);

%% Start using the log file
Message(1,1,1,'Asking for new file', 'UDEF',RunID); %Creating a new log file (by using the third "1" in the function parameters)
Message(1,1,0,['Local directory is : ' cd ], 'UDEF', RunID); %Loging the cd

%% Local variable definition
occured_error = 0;
GetParameters;
dpmm = dpi*25.4;% conversion from "dot per inch" to "dot per mm"
%% Code
% opening image
ImageName = 'P1_603010_ST_02.jpg';% doing that because of the .mat saving
ImageMatrix = imread([cd '\Images\' ImageName]);
% ImageMatrix = imresize(ImageMatrix,0.25) ;
figure;imshow(imrotate(ImageMatrix,180));

bw1 = im2bw(ImageMatrix, 0.1); % Otsu's algorithm

if Plot_debug
    %Nathan debug
    %--------------------------
    figure;imshow(bw1);
    %--------------------------
end

bw1 = imcomplement(bw1);
[label, numLabels] =   bwlabeln(bw1,8);


%Nathan : Show the result of the labelling for debugging purposes
%-------------------------------------
RGB_label = label2rgb(label, @copper, 'c', 'shuffle');
figure();
imshow(RGB_label,'InitialMagnification','fit')
%-------------------------------------

maxBorder = zeros(numLabels);

for k = 1:numLabels
    %-------------------------------------
    object{k} = (label == k);
    figure();imshow(object{k});
    %-------------------------------------
    
    for cpt_column = 1 : size(object{k},2) % take the number of columns
        Index_temp = find(object{k}(:,cpt_column));
        if ~isempty(Index_temp)
            Index_Alone = round(mean(Index_temp));
            id = find(Index_temp==Index_Alone);
            Index_temp(id)=[];
            object{k}(Index_temp,cpt_column) = 0;
        end
    end
    [fcy, fcx] = find(object{k});
    fcy = abs(fcy - size(object{k},1));
    [~,sortedIndex] = sort(fcx);
    fcx = fcx(sortedIndex);
    fcy = fcy(sortedIndex);
    if length(fcx) > 100 && length(fcy) > 100
        fcy = smooth(fcy, 'rlowess'); % Uses 'rlowess' method
        % %     ii=find(object{k});
        % %     [fcy,fcx]=ind2sub(size(object{k}),ii);
        %fit a spline throught the detected line
        
        % % %     %we need to invert the y axis because the prvious fyunction count from
        % % %     %the top down
        % % %     fcx = abs(fcx-max(fcx));
        
        % DETERMINE spacing between interpolation points
        intrpl1Spacing = floor(length(fcx)/numIntrplPts_spl);
        
        % SELECT data points to interpolclose all
        %         ate from
        last_temp = find(fcx == fcx(end));
        intrplPts1Indices = [(1 : intrpl1Spacing : intrpl1Spacing * numIntrplPts_spl - intrpl1Spacing),...
            last_temp(end)];
        intrplx = fcx(intrplPts1Indices);
        
        % regression lineaire sur la pente finale
        final_solpe_points = intrpl1Spacing * numIntrplPts_spl - intrpl1Spacing:length(fcy);
        coefficients = polyfit(fcx(final_solpe_points), fcy(final_solpe_points), 1); % Gets coefficients of the formula.
        % Now get the y values.
        fittedY = polyval(coefficients, fcx(end));
        
        
        %     intrply = [fcy(intrplPts1Indices(1:end-1)); MeanEndSlope*fcx(end)];
        figure();
        %     plot(intrplx, [fcy(intrplPts1Indices(1:end-1)); MeanEndSlope*fcx(end)]);
        %     hold on;
        plot(intrplx, [fcy(intrplPts1Indices(1:end-1)); fittedY]);
        intrply = [fcy(intrplPts1Indices(1:end-1)); fittedY];
        
        
        % PERFORM cubic spline interpolation
        % Other spline interpolation functions: csaps, csapi, spline, polyval
        Myspline = csape(intrplx, intrply, 'variational'); % pp form
        % Evaluate at all consolidated points
        splinevalx = fcx;
        splinevaly = fnval(Myspline, splinevalx);
        
        %-------------------------------------
        figure();
        plot(fcx,fcy,'bs-');
        hold on;
        plot(splinevalx,splinevaly,'r*-');
        grid on;
        axis equal;
        %-------------------------------------
        close all;
        %save the spline x and y data for after
        save([cd '\Data\Spline\' 'Image_' ImageName '_Spline_'  num2str(k) '.mat'],'k','ImageName','splinevalx','splinevaly');
        
        
        %If you crop, I let you guess what happens to the X and Y
        %coordiantes
        %SplineImageCrop;
        
        %-------------------------------------
        %     object{k} = imcrop(object{k},BB); %#ok<SAGROW>
        %     figure();imshow(object{k});
        %-------------------------------------
        
    end
end



Message(1,1,0,'End of the Matlab', 'UDEF', RunID);