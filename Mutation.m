function mut_children = Mutation(co_children, mp, ps)
    for i = 1:ps
%         r = rand(size(co_children,2),1); % Random number for each bit of the string
        for j = 1:size(co_children,2)
            r = rand();
            if r < mp
                if co_children(i,j) == 0
                    co_children(i,j) = 1; % 0 to 1
                else
                    co_children(i,j) = 0; % 1 to 0
                end
            end
        end
    end
    mut_children = co_children;
end