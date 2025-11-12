function matrix_G = G_extractor (critic , angle_list)

matrix_G = zeros( 125 , 2 , numel(angle_list) );

for rule = 1:125

    for angle = 1:numel(angle_list)

        origin = critic (rule) . minimum_pareto;

        D = abs ( (critic (rule).pareto(: , 1) - origin (1) ) * sin (angle_list(angle)) - (critic (rule).pareto(: , 2) - origin (2) ) * cos (angle_list(angle)) );

        [~ , pareto_select] = min(D);

        matrix_G (rule , : , angle) = critic (rule).pareto (pareto_select , :);

    end

end

