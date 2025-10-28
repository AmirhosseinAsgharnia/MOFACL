function actor_weights = G_test (critic , actor , angle_list)

number_of_rules = numel (actor);

actor_weights = zeros (number_of_rules , 3);

angle_list = linspace (0 , pi/2 , 10);

for rule = 1 : number_of_rules

    origin = critic (rule) . minimum_pareto;

    for i = 1:3
        D = abs ( (critic (rule) . pareto (: , 1) - origin (1) ) * sin (angle_list(i)) - ...
            (critic (rule) . pareto (: , 2) - origin (2) ) * cos (angle_list(i)) );

        [~ , select] = min (D );

        actor_weights (rule , i) = actor(rule).pareto(select);

    end

end

