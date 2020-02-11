% In which interval is this number?
%can be optimised using the "find" function since intervals are stacked

%interval is given as a vector of the interval position (contiguous)

% for example [1 5 36.5 78] means the interval are:
%     ]-Inf 1[      --> index = -1 ("value" is outside lower boundary)
%     [1 5[         --> index = 1
%     [5 36.5[      --> index = 2
%     [36.5 78[     --> index = 3
%     [78 +Inf[     --> index = -2 ("value" is outside upper boundary)

% Want to try?
% use this code
% interval=[1 5 36.5 78]
% MyFindInInterval(1,interval)
% MyFindInInterval(0.5,interval)
% MyFindInInterval(78,interval)
% MyFindInInterval(79,interval)
% 
% MyFindInInterval(5,interval)
% MyFindInInterval(36.5,interval)



function   index = MyFindInInterval(value,interval)

index = NaN; %default "bad"

if issorted(interval)
    if ~(value<interval(1) || value >= interval(end)) %direct check if "value" is inside the given boundaries
        n = length(interval) - 1;% this is an open interval
        indexfound = zeros(n, 1);%init
        for i = 1:n % iteration on the smaller intervals created: slow
            temp = find(value>=interval(i) & value<interval(i+1));
            if ~isempty(temp) %if there is a returned value, then it is in the boundaries of the smaller intervals created
                indexfound(i) = temp;
                clear 'temp';
            end
        end
        
        if ~isempty(indexfound)
            index = find(indexfound); % if the bins have been corrected defined,
            %     then there should be no more than one non null value of "indexfound" 
        end
    else % "value" is outside the given boundaries
        %now check which of the lower or the upper boundary is reached
        if value<interval(1) %"value" is outside lower boundary
            index = -1;
        else %"value" is outside upper boundary
            index = -2;
        end
    end 
end


end