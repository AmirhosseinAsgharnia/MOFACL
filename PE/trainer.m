

sample_list = randi([1 1],1,1);

if terminate == 1 || terminate == 2
    sample_list = 1;
end

for sample = sample_list


    S_1 = replay_buffer(sample).s_1;
    S_2 = replay_buffer(sample).s_2;

    U  = replay_buffer(sample).u;
    Up = replay_buffer(sample).up;

    R_1 = replay_buffer(sample).r_1;
    R_2 = replay_buffer(sample).r_2;

    T = replay_buffer(sample).terminate;

    angle = replay_buffer(sample).angle;

    c_select = replay_buffer(sample).select;

    Fuzzy_test.weights = zeros (number_of_rules , 1);

    active_rules_1 = fuzzy_engine_3 (S_1 , Fuzzy_test); % Just to check which rules are going be fired.

    active_rules_2 = fuzzy_engine_3 (S_2 , Fuzzy_test);

    %% calculating v_{t}

    v_weighted = zeros (numel(active_rules_1.act) , number_of_objectives );

    j = 1;

    for rule = active_rules_1.act'

        v_weighted(j , 1) = critic(rule).members(c_select(j) , 1);

        v_weighted(j , 2) = critic(rule).members(c_select(j) , 2);

        j = j + 1;

    end

    V_s_1 = zeros (1 , 2);

    Fuzzy_critic.weights = zeros (number_of_rules , 1);

    Fuzzy_critic.weights(active_rules_1.act) = v_weighted (: , 1);

    V_s_1 (1) = fuzzy_engine_3 ( S_1 , Fuzzy_critic ).res;

    Fuzzy_critic.weights(active_rules_1.act) = v_weighted (: , 2);

    V_s_1 (2) = fuzzy_engine_3 ( S_1 , Fuzzy_critic ).res;

    %% calculating v_{t+1}

    V_s_2 = zeros (number_of_angle , 2);

    % if angle == 1
    %     ang_list = [1 2];
    % elseif angle == 10
    %     ang_list = [9 10];
    % else
    %     ang_list = [angle-1,angle,angle+1];
    % end

    for i = 1:number_of_angle

        Fuzzy_critic.weights = zeros (number_of_rules , 1);

        Fuzzy_critic.weights(active_rules_2.act , 1) = matrix_G (active_rules_2.act , 1 , i);

        V_s_2 (i , 1) = fuzzy_engine_3 ( S_2 , Fuzzy_critic ).res;

        Fuzzy_critic.weights = zeros (number_of_rules , 1);

        Fuzzy_critic.weights(active_rules_2.act , 1) = matrix_G (active_rules_2.act , 2 , i);

        V_s_2 (i , 2) = fuzzy_engine_3 ( S_2 , Fuzzy_critic ).res;

    end

    if T~=0
        V_s_2 = V_s_2 * 0;
    end

    %% calculating temporal difference (Delta)

    Delta = [R_1 , R_2] + discount_factor * V_s_2 - V_s_1;

    %% updating actor and critic

    firing_strength_counter = 0;

    for rule = active_rules_1.act'

        firing_strength_counter = firing_strength_counter + 1;

        for i = 1:number_of_angle

            New_critics = critic(rule).members(c_select(firing_strength_counter),:) + critic_learning_rate * Delta(i , :) * active_rules_1.phi(firing_strength_counter);

            critic(rule).members = [critic(rule).members ; New_critics];

            [R_x , R_y] = delta_direction_calculator(angle_list(angle) , critic(rule).maximum_members , critic(rule).members(c_select(firing_strength_counter),:) , New_critics);

            New_actors = actor(rule).members(c_select(firing_strength_counter)) +...
                actor_learning_rate * sign(Up - U) * ( Delta(i,1)*sin(angle_list(i)) +  Delta(i,2)*cos(angle_list(i))) * active_rules_1.phi(firing_strength_counter);

            New_actors = max(min(New_actors , pi/6) , -pi/6);

            actor(rule).members = [actor(rule).members ; New_actors];

            critic(rule).index = [critic(rule).index ; 0];

            critic(rule).crowding_distance = [critic(rule).crowding_distance ; 0];

        end

        critic(rule).members(c_select(firing_strength_counter),:) = [];
        actor(rule).members(c_select(firing_strength_counter)) = [];
        critic(rule).crowding_distance(c_select(firing_strength_counter)) = [];
        critic(rule).index(c_select(firing_strength_counter)) = [];

        [critic(rule).members , unique_index] = unique(critic(rule).members , "rows");
        actor(rule).members = actor(rule).members(unique_index);
        critic(rule).crowding_distance = critic(rule).crowding_distance(unique_index);
        critic(rule).index = critic(rule).index(unique_index);

        [critic , actor] = pareto_synthesizer (critic , actor , rule , max_repo_member);

        critic(rule).maximum_members = max (critic(rule).members , [] , 1);
        critic(rule).maximum_pareto = max (critic(rule).pareto , [] , 1);

    end
end