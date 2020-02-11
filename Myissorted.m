function   boolean = Myissorted(vector)

% My function is faster: 0.002835 seconds. against 0.000629 seconds. for vector = [10 50 20]

if ~isvector(vector)
    error('Dimention of input vector must be exactly 2');
end

boolean = 0; % Default is false

temp = unique(vector);
if length(temp) == length(vector)
    if vector == temp
        boolean = 1;
    end
end

end