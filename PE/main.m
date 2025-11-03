close all; clear; clc

if isfolder('Figs'); rmdir("Figs","s"); end

rng(145)

mkdir("Figs")
%% simulation time parameters

max_episode = 2000; % maximum times a whole game is played.

test_episode = 20; % each "test_episode" a test without noise is conducted.

max_time_horizon = 200; % maximum duration of each epoch.

step_time = 0.1; % step time. (100 ms)

max_iteration = max_time_horizon / step_time + 1;

simulation_time = zeros (max_episode , 1);

%% game parameters

dimension = 50;

speed = 5; % speed of the agent (units/sec)

position_goal = [40 , 40];

position_pit  = [40 , 20];

capture_radius = 3;

gama_data.dimension = dimension;
gama_data.speed = speed;
gama_data.position_goal = position_goal;
gama_data.position_pit = position_pit;
gama_data.capture_radius = capture_radius;

%% hyper parameters

actor_learning_rate = 0.05;

critic_learning_rate = 0.05;

discount_factor = 0.5;

number_of_angle = 5;

max_repo_member = 10;

angle_list = linspace (0 , pi/2 , number_of_angle);

sigma = 0.4;

%% algorithm parameters

number_of_objectives = 2;

number_of_inputs = 3;

number_of_membership_functions = 5;

number_of_rules = number_of_membership_functions ^ number_of_inputs;

%% fuzzy engine prepration (actor main)

Fuzzy_actor.input_number = number_of_inputs;
Fuzzy_actor.weights = zeros(number_of_rules , 1);
Fuzzy_actor.membership_fun_number = number_of_membership_functions;
Fuzzy_actor.input_bounds = [0 dimension;0 dimension;-pi pi];

%% fuzzy engine prepration (actor main)

Fuzzy_critic.input_number = number_of_inputs;
Fuzzy_critic.weights = zeros(number_of_rules , number_of_objectives);
Fuzzy_critic.membership_fun_number = number_of_membership_functions;
Fuzzy_critic.input_bounds = [0 dimension;0 dimension;-pi pi];

%% fuzzy engine prepration (actor test)

Fuzzy_test.input_number = number_of_inputs;
Fuzzy_test.weights = zeros(number_of_rules , 1);
Fuzzy_test.membership_fun_number = number_of_membership_functions;
Fuzzy_test.input_bounds = [0 dimension;0 dimension;-pi pi];

%% critic spaces

critic.members = 0 * ones ( max_repo_member , number_of_objectives);

critic.index = 0 * ones ( max_repo_member , 1);

critic.crowding_distance = 0 * ones ( max_repo_member , 1);

critic.minimum_members = 0*ones ( 1 , number_of_objectives);

critic.pareto = 0 * ones ( 1 , number_of_objectives);

critic.minimum_pareto = 0*ones ( 1 , number_of_objectives);

critic.selected = 1;

critic = repmat (critic , number_of_rules , 1);

%% actor spaces

actor.members = 0 * ones ( max_repo_member , 1);

actor.pareto = 0 * ones ( 1 , 1);

actor = repmat (actor , number_of_rules , 1);

%%

for rule = 1 : number_of_rules

    critic(rule).minimum_pareto = min (critic(rule).pareto , [] , 1);

    critic(rule).minimum_members = min (critic(rule).members , [] , 1);

end


%% training loop

test_count = 0;

for episode = 1 : max_episode

    % sigma = sigma * 10 ^ (log10(0.2)/max_episode);
    % actor_learning_rate  = actor_learning_rate * 10 ^ (log10(0.5)/max_episode);
    % critic_learning_rate = critic_learning_rate * 10 ^ (log10(0.5)/max_episode);

    terminate = 0;
    iteration = 0;

    %% episode simulation

    position_agent = zeros (max_iteration , 3);
    position_agent (1 , :) = [dimension * rand , dimension * rand , 2 * pi * rand - pi];
    % position_agent (1 , :) = [0 0 pi/4];
    tic
    
    while ~terminate && iteration < max_iteration

        iteration = iteration + 1;

        actor_output_parameters = zeros(number_of_rules , 1);

        %% fired rules (state s)

        active_rules_1 = fuzzy_engine_3 ([position_agent(iteration , 1) , position_agent(iteration , 2) , position_agent(iteration , 3)] , Fuzzy_test); % Just to check which rules are going be fired.

        %% pre-processing the rule-base and exploration - exploitation (distance from origin) (ND is applyed before!)

        angle = randi ([1 number_of_angle]);

        for rule = active_rules_1.act'

            Distances = distance_from_vector( angle_list(angle), critic(rule).minimum_members , critic(rule).members );

            [~ , select] = min (Distances);

            critic(rule).selected = select;

            actor_output_parameters(rule) = actor(rule).members (critic(rule).selected);

        end

        %% selecting action

        Fuzzy_actor.weights = actor_output_parameters;

        u = fuzzy_engine_3 ([position_agent(iteration , 1) , position_agent(iteration , 2) , position_agent(iteration , 3)] , Fuzzy_actor);

        up = u.res + sigma * randn;

        %% taking action

        p = ode4(@(t , y) agent(t , y , up , speed) , [0 step_time] , position_agent(iteration , :));

        position_agent(iteration + 1 , :) = p(end , :);

        position_agent(iteration + 1 , 3) = ang_adj(position_agent(iteration + 1 , 3));

        position_agent = border(position_agent , iteration);

        terminate = termination (iteration , capture_radius , position_agent , position_goal , position_pit);

        %% fired rules (state s')

        Fuzzy_test.weights = zeros (number_of_rules , 1);

        active_rules_2 = fuzzy_engine_3 ([position_agent(iteration + 1, 1) , position_agent(iteration + 1 , 2) , position_agent(iteration + 1 , 3)] , Fuzzy_test);

        %% reward calculation

        [reward_1 , reward_2] = reward_function (iteration , position_agent , position_goal , position_pit);

        %% calculating v_{t}

        v_weighted = zeros (numel(active_rules_1.act) , number_of_objectives );

        j = 1;

        for rule = active_rules_1.act'

            v_weighted(j , 1) = critic(rule).members(critic(rule).selected , 1);

            v_weighted(j , 2) = critic(rule).members(critic(rule).selected , 2);

            j = j + 1;

        end

        V_s_1 = zeros (1 , 2);

        Fuzzy_critic.weights = zeros (number_of_rules , 1);

        Fuzzy_critic.weights(active_rules_1.act) = v_weighted (: , 1);

        V_s_1 (1) = fuzzy_engine_3 ( [position_agent(iteration , 1) , position_agent(iteration , 2) , position_agent(iteration , 3)] , Fuzzy_critic ).res;

        Fuzzy_critic.weights(active_rules_1.act) = v_weighted (: , 2);

        V_s_1 (2) = fuzzy_engine_3 ( [position_agent(iteration , 1) , position_agent(iteration , 2) , position_agent(iteration , 3)] , Fuzzy_critic ).res;

        %% calculating v_{t+1}

        matrix_G = G_extractor (critic , active_rules_2 , angle_list);

        V_s_2 = zeros (number_of_angle , 2);

        for i = 1:number_of_angle

            Fuzzy_critic.weights = zeros (number_of_rules , 1);

            Fuzzy_critic.weights(active_rules_2.act , 1) = matrix_G (: , 1 , i);

            V_s_2 (i , 1) = fuzzy_engine_3 ( [position_agent(iteration + 1, 1) , position_agent(iteration + 1 , 2) , position_agent(iteration + 1 , 3)] , Fuzzy_critic ).res;

            Fuzzy_critic.weights = zeros (number_of_rules , 1);

            Fuzzy_critic.weights(active_rules_2.act , 1) = matrix_G (: , 2 , i);

            V_s_2 (i , 2) = fuzzy_engine_3 ( [position_agent(iteration + 1, 1) , position_agent(iteration + 1 , 2) , position_agent(iteration + 1 , 3)] , Fuzzy_critic ).res;

        end

        if terminate
            V_s_2 = V_s_2 * 0;
        end

        %% calculating temporal difference (Delta)
        
        if terminate == 1
            reward_1 = reward_1 + 2;
        elseif terminate == 2
            reward_2 = reward_2 - 2;
        end
        Delta = [reward_1 , reward_2] + discount_factor * V_s_2 - V_s_1;        
        
        %% updating actor and critic

        firing_strength_counter = 0;

        for rule = active_rules_1.act'

            firing_strength_counter = firing_strength_counter + 1;

            for i = 1 : number_of_angle

                New_critics = critic(rule).members(critic(rule).selected,:) + critic_learning_rate * Delta(i , :) * active_rules_1.phi(firing_strength_counter);

                critic(rule).members = [critic(rule).members ; New_critics];

                [R_x , R_y] = delta_direction_calculator(angle_list(angle) , critic(rule).minimum_members , critic(rule).members(critic(rule).selected,:) , New_critics);
                
                New_actors = actor(rule).members(critic(rule).selected) + actor_learning_rate * sign(up - u.res) * ( sign(R_x) * abs(Delta(i,1)) +  sign(R_y) * abs(Delta(i,2))) * active_rules_1.phi(firing_strength_counter);

                New_actors = max(min(New_actors , pi/6) , -pi/6);

                actor(rule).members = [actor(rule).members ; New_actors];
                
                critic(rule).index = [critic(rule).index ; 0];

                critic(rule).crowding_distance = [critic(rule).crowding_distance ; 0];
            end

            critic(rule).members(critic(rule).selected,:) = [];
            actor(rule).members(critic(rule).selected) = [];
            critic(rule).crowding_distance(critic(rule).selected) = [];
            critic(rule).index(critic(rule).selected) = [];

            [critic(rule).members , unique_index] = unique(critic(rule).members , "rows");
            actor(rule).members = actor(rule).members(unique_index);
            critic(rule).crowding_distance = critic(rule).crowding_distance(unique_index);
            critic(rule).index = critic(rule).index(unique_index);

            [critic , actor] = pareto_synthesizer (critic , actor , rule , max_repo_member);

            critic(rule).minimum_members = min (critic(rule).members , [] , 1);
            critic(rule).minimum_pareto = min (critic(rule).pareto , [] , 1);

        end
    end

    simulation_time (episode) = toc;

    fprintf ("--------------------------------------------------------\n");
    fprintf ("Episode = %.0d.\n" , episode );
    fprintf ("The process is %.2f%% completed.\n" , episode * 100 / max_episode);
    fprintf ("Episode training took %.1f seconds.\n" , simulation_time (episode));
    fprintf ("--------------------------------------------------------\n");

    if mod( episode , test_episode ) == 0 || episode == 1

        test_count = test_count + 1;
        fprintf ("--------------------------------------------------------\n");
        fprintf ("Test number %d has been started.\n" , test_count);
        fprintf ("--------------------------------------------------------\n");

        actor_weights = G_test (critic , actor , angle_list);

        i=1;
        Fuzzy_actor.weights = actor_weights;
        algorithm_test (Fuzzy_actor , episode , gama_data , i);
        pareto_test (critic , actor , episode );
        % save(sprintf("policy.mat" ))

    end

end