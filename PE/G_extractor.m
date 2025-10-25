function matrix_G = G_extractor (critic , active_rules , angle , angle_list)

matrix_G = zeros(numel(active_rules.act) , 2);

i = 1;

for rule = active_rules.act'
    
    origin = critic (rule) . minimum_pareto;
    
    D = abs ( (critic (rule) . pareto (: , 1) - origin (1) ) * sin (angle_list(angle)) - (critic (rule) . pareto (: , 2) - origin (2) ) * cos (angle_list(angle)) );
    
    [~ , pareto_select] = min(D);

    matrix_G (i,:) = critic (rule) . pareto (pareto_select , :);
    
    i = i + 1;
end

