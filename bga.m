clear; clc;

%% Input for the user

fp = fopen("input.txt",'r');
nv = str2double(fgetl(fp)); % Number of Variables
ps = str2double(fgetl(fp)); % Population Size
cp = str2double(fgetl(fp)); % Crossover Probability
mp = str2double(fgetl(fp)); % Mutation Probabilty
max_gen = str2double(fgetl(fp)); % Maximum Number of Generations
fclose(fp);

fp = fopen("variable_bounds.txt", 'r');
x = zeros(nv, 3);
for i = 1:nv
    x(i,1) = str2double(fgetl(fp)); % Minimun of variable
    x(i,2) = str2double(fgetl(fp)); % Maximum of variable
    x(i,3) = str2double(fgetl(fp)); % Accuracy of variable
end
fclose(fp);

%% Length of Sub-strings and Total length of string

l = zeros(nv,1);
for i = 1:nv
    l(i) = ceil(log((x(i,2) - x(i,1)) / x(i,3)) / log(2));
end

% Total length of one string
ls = sum(l);

%% Generating a Population and Function Values

population = randi([0, 1], ps, ls);
Best_Sol = [];
Worst_Sol = [];
Gen_Avg = [];
Avg_f_val = zeros(11,2);
gen = 1;
actual_gen = 1;

x_val(:,:,gen) = bintodec(population, x(:,1:2), l);
for i = 1:ps
    of_value(i,gen) = Objective_Function(x_val(i,:,gen));
end
f_values(:,gen) = Fitness_Values(x_val(:,:,gen));
[Min_fitness, index] = min(f_values(:,gen));
Worst_Sol = [Worst_Sol; Min_fitness, x_val(index,:,gen)];
[Max_fitness, idx] = max(f_values(:,gen));
Best_Sol = [Best_Sol; Max_fitness, x_val(idx,:,gen)];
Gen_Avg = [Gen_Avg; gen, mean(f_values(:,gen))];
Avg_f_val(end, :) = [gen, mean(f_values(:,gen))];

while (gen <= max_gen && Avg_f_val(1,2) ~= Avg_f_val(end,2))

    %% Reproduction

    mating_pool = Roulette_Wheel(population, f_values, ps);

    %% Crossover

    co_children = Crossover(mating_pool, cp, ps);

    %% Mutation

    mut_children = Mutation(co_children, mp, ps);

    %% For Next Generation

    actual_gen = actual_gen + 1;
    fit_pop = Fitness_Values(bintodec(population, x(:,1:2), l));
    fit_mut = Fitness_Values(bintodec(mut_children, x(:,1:2), l));

    if mean(fit_mut) >= mean(fit_pop)
        population = mut_children;
        gen = gen + 1;
        x_val(:,:,gen) = bintodec(population, x(:,1:2), l);
        for i = 1:ps
            of_value(i,gen) = Objective_Function(x_val(i,:,gen));
        end
        f_values(:,gen) = Fitness_Values(x_val(:,:,gen));
        [Min_fitness, index] = min(f_values(:,gen));
        Worst_Sol = [Worst_Sol; Min_fitness, x_val(index,:,gen)];
        [Max_fitness, idx] = max(f_values(:,gen));
        Best_Sol = [Best_Sol; Max_fitness, x_val(idx,:,gen)];
        Gen_Avg = [Gen_Avg; gen, mean(f_values(:,gen))];
        Avg_f_val = [Avg_f_val(2:end,:); gen, mean(f_values(:,gen))];
    end

end

%% Final Results

fprintf(['Total no. of generation = ', num2str(gen), '(Considering initial as generation-1)']);
fprintf('\nPopulation in the end:');
Population = population % Population at the end
fprintf('\nX Values in the end:');
X_Values = x_val(:,:,end) % X Values at the end
fprintf('\nFitness Values in the end:');
Fitness_Values = f_values(:,end) % Fitness Values at the end
fprintf('\nObjective Function Values in the end:');
Objective_Function_Values = of_value(:,end) % Original Function Value at the end

fig1 = figure('Name', 'Average Fitness Value vs. Generations');
plot(Gen_Avg(:,1), Gen_Avg(:,2), '-*r');
legend('Avg. Fit. Value', 'Location', 'southeast');
xlim([1, size(Gen_Avg,1)]);
xlabel('Generations');
ylabel('Average Fitness Value');
hold off;
saveas(fig1, 'Average Fitness Value vs. Generations.jpg');

fig2 = figure('Name', 'Max and Min Fitness Value vs. Generations');
plot(Gen_Avg(:,1), Best_Sol(:,1), '--*g');
hold on;
plot(Gen_Avg(:,1), Worst_Sol(:,1), '-.sr');
legend('Max. Fit. Value', 'Min. Fit. Value', 'Location', 'southeast');
xlim([1, size(Gen_Avg,1)]);
xlabel('Generations');
ylabel('Max-Min Fitness Value');
hold off;
saveas(fig2, 'Max and Min Fitness Value vs. Generations.jpg');

fig3 = figure('Name', 'Optimum Fitness Value vs. Generations');
plot(Gen_Avg(:,1), Best_Sol(:,1), '-*b');
legend('Opt. Fit. Value', 'Location', 'southeast');
xlim([1, size(Gen_Avg,1)]);
xlabel('Generations');
ylabel('Optimum Fitness Value');
hold off;
saveas(fig3, 'Optimum Fitness Value vs. Generations.jpg');

fig4 = figure('Name', 'X Values vs. Generations');
for i = 1:gen
    plot(x_val(:,1,i), x_val(:,2,i), '*r');
    xlim(x(1,1:2));
    ylim(x(2,1:2));
    xlabel('x_1');
    ylabel('x_2');
    title(['Generation no. = ', num2str(i)]);
    M(i) = getframe;
end