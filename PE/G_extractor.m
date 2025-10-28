function matrix_G = G_extractor (critic , active_rules , angle_list)

matrix_G = zeros( numel(active_rules.act) , 2 , numel(angle_list) );

i = 1;

for rule = active_rules.act'

    for angle = 1:numel(angle_list)

        origin = critic (rule) . minimum_pareto;

        D = abs ( (critic (rule).pareto(: , 1) - origin (1) ) * sin (angle_list(angle)) - (critic (rule).pareto(: , 2) - origin (2) ) * cos (angle_list(angle)) );

        [~ , pareto_select] = min(D);

        matrix_G (i , : , angle) = critic (rule).pareto (pareto_select , :);

    end

    i = i + 1;

end

