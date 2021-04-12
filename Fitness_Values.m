function f_values = Fitness_Values(x_values)
    f_values = zeros(size(x_values,1),1);
    for i = 1:length(f_values)
        f_values(i) = 1 / (1 + Objective_Function(x_values(i,:))); % Can be changes according to minimization or maximization
    end
end