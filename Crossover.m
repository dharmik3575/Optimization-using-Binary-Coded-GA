function co_children = Crossover(parents, cp, ps)
    r = [];
    while size(r) ~= ps
        for i = 1:ps
            random = randi([1, ps]);
            if isempty(find(random == r, 1))
                r = [r; random]; % Making random pairs of total parents
            end
        end
    end
    
    for i = 1:ps/2
        ran = rand();
        if ran < cp % Comparing with crossover probability
            co_sites = sort(randi([1, size(parents,2)-1], 2, 1)); % Random crossover sites
            while co_sites(1) == co_sites(2)
                co_sites = sort(randi([1, size(parents,2)-1], 2, 1)); % Random crossover sites
            end
            parents(r(2*i-1),:) = [parents(r(2*i-1),1:co_sites(1)), parents(r(2*i),co_sites(1)+1:co_sites(2)), parents(r(2*i-1),co_sites(2)+1:end)];
            parents(r(2*i),:) = [parents(r(2*i),1:co_sites(1)), parents(r(2*i-1),co_sites(1)+1:co_sites(2)), parents(r(2*i),co_sites(2)+1:end)];
        end
    end
    
    co_children = parents;
end