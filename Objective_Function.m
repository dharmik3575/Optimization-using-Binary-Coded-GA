function f_val = Objective_Function(x)
    f_val = x(1) + x(2) - 2*x(1)^2 - x(2)^2 + x(1)*x(2); % Minimize
end