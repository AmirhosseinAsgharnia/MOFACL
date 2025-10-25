function actor_weights = G_test_2 (critic , actor , angle)

number_of_rules = numel (actor);

actor_weights = zeros (number_of_rules , 3);

for rule = 1 : number_of_rules

    D_1 = find (critic(rule).pareto_index == angle);
    
    if ~isempty(D_1)
        D_2 = distance_real (critic(rule).pareto_members(D1,:),critic(rule).minimum_pareto);
        [~ , D_3] = max(D_2); 
        actor_weights(rule) = actor(rule).pareto_members (D_3,:);
    else
        D_1 = find (critic(rule).index == angle);
        D_2 = distance_real (critic(rule).members , critic(rule).minimum_members);
        [~ , D_3] = max(D_2);
        actor_weights(rule) = actor(rule).members (critic(rule).best_value_index);
    end

end

