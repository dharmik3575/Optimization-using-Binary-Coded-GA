function mating_pool = Roulette_Wheel(population, f_values, ps)
    mating_pool = [];
    prob_string = f_values / sum(f_values); % Probabilities of Strings
    [prob_string, idx] = sort(prob_string); % Ranking of Probabilities
    prob_string = cumsum(prob_string); % Cumulative Sum by Ranking
    
    for i = 1:ps
        r = rand(); % Random Number Generator in between [0, 1]
        for j = 1:ps
            if r < prob_string(j)
                mating_pool(i,:) = population(idx(j),:);
                break
            end
        end
    end
end
