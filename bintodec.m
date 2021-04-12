function x = bintodec(bin_values, variable_bounds, sub_string_lengths)
    x = zeros(size(bin_values,1), 2);
    for i = 1:size(bin_values,1)
        x(i,1) = bin2dec(num2str(bin_values(i,1:sub_string_lengths(1))));
        x(i,2) = bin2dec(num2str(bin_values(i,sub_string_lengths(1)+1:sub_string_lengths(1)+sub_string_lengths(2))));
        x(i,1) = variable_bounds(1,1) + ((variable_bounds(1,2) - variable_bounds(1,1)) / (2^sub_string_lengths(1) - 1)) * x(i,1);
        x(i,2) = variable_bounds(2,1) + ((variable_bounds(2,2) - variable_bounds(2,1)) / (2^sub_string_lengths(2) - 1)) * x(i,2);
    end
end