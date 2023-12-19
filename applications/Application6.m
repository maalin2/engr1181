clc
clear

%% Warmup Problem 
for N = 1:500 

    if sum (1:N) > 1000
        break
    end

end
fprintf('The sum of integers from 1 through %i exceeds 1000\n', N)

% Repeat the above using a while loop
n = 1;
sum2 = n;

while sum2 < 1000
    n = n + 1;
    sum2 = sum2 + n;
end
fprintf('The sum of integers from 1 through %i exceeds 1000\n', n)

%% Application Problem
% load data - weights of cargo items in pounds

cargo_weights=load('cargo_data.txt');

%Set maximum capacity of the cargo plane

capacity = 5000; 

%Store loaded cargo items
loaded = [];

% Solve the problem using a for loop
for i = 1:length(cargo_weights)
    cargo = cargo_weights(i);

    if cargo > capacity
        break
    end

    loaded(i) = cargo;
    capacity = capacity - cargo;
end

% Print results to the command window as specified in the instructions
fprintf("The total weight loaded is %i pounds, and the unused capacity " + ...
    "is %i pounds.\n", sum(loaded), capacity);

% Solve the problem using a while loop
cargo = 0;
j = 0;
capacity = 5000;

while cargo <= capacity
    j = j + 1;
    cargo = cargo_weights(j);
    loaded(j) = cargo;
    capacity = capacity - cargo;
end

% Print results to the command window as specified in the instructions
fprintf("The total weight loaded is %i pounds, and the unused capacity " + ...
    "is %i pounds.\n", sum(loaded), capacity);
	