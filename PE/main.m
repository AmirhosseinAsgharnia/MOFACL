close all; clear; clc

if isfolder('Figs'); rmdir("Figs","s"); end

rng(145)

mkdir("Figs")
%% simulation time parameters

max_episode = 10000; % maximum times a whole game is played.

test_episode = 20; % each "test_episode" a test without noise is conducted.

max_time_horizon = 200; % maximum duration of each epoch.

step_time = 0.1; % step time. (100 ms)

max_iteration = max_time_horizon / step_time + 1;

simulation_time = zeros (max_episode , 1);

buffer_size = 50;
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

actor_learning_rate = 0.01;

critic_learning_rate = 0.01;

discount_factor = 0.5;

number_of_angle = 10;

max_repo_member = 10;

angle_list = linspace (0 , pi/2 , number_of_angle);

sigma = 1;

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

critic.members = .1 * randn ( max_repo_member , number_of_objectives);

critic.index = 1 * ones ( max_repo_member , 1);
% critic.label = 1:10;
critic.crowding_distance = 0 * ones ( max_repo_member , 1);

critic.maximum_members = 0*ones ( 1 , number_of_objectives);

critic.pareto = 0 * ones ( 1 , number_of_objectives);

critic.maximum_pareto = 0*ones ( 1 , number_of_objectives);

critic.selected = 1;

critic = repmat (critic , number_of_rules , 1);

%% actor spaces

actor.members = 1 * zeros ( max_repo_member , 1)*0.1;

actor.pareto = 0 * ones ( 1 , 1);

actor = repmat (actor , number_of_rules , 1);

%%

for rule = 1 : number_of_rules

    critic(rule).maximum_pareto = max (critic(rule).pareto , [] , 1);

    critic(rule).maximum_members = max (critic(rule).members , [] , 1);

end

%% Experience Buffer

empty.s_1 = [];
empty.s_2 = [];

empty.u = [];
empty.up = [];

empty.r_1 = [];
empty.r_2 = [];

empty.select = [];

empty.terminate = [];

empty.angle = [];

replay_buffer = repmat(empty, buffer_size , 1);
%% training loop

test_count = 0;
rp = 0;

for episode = 1 : max_episode
    
    

    % sigma = sigma * 10 ^ (log10(0.2)/max_episode);
    % actor_learning_rate  = actor_learning_rate * 10 ^ (log10(0.5)/max_episode);
    % critic_learning_rate = critic_learning_rate * 10 ^ (log10(0.5)/max_episode);

    terminate = 0;
    iteration = 0;

    %% episode simulation

    position_agent = zeros (max_iteration , 3);
    % position_agent (1 , :) = [dimension * rand , dimension * rand , 2 * pi * rand - pi];
    position_agent (1 , :) = [0 0 pi/4];
    tic
    
    while ~terminate && iteration < max_iteration
        rp = rp + 1;

        iteration = iteration + 1;

        actor_output_parameters = zeros(number_of_rules , 1);

        %% fired rules (state s)

        active_rules_1 = fuzzy_engine_3 ([position_agent(iteration , 1) , position_agent(iteration , 2) , position_agent(iteration , 3)] , Fuzzy_test); % Just to check which rules are going be fired.

        %% pre-processing the rule-base and exploration - exploitation (distance from origin) (ND is applyed before!)
        
        % if mod(iteration , 5) == 0 || iteration == 1
        angle = randi ([1 number_of_angle]);
        % end

        C_select = zeros(8 , 1);

        counter = 0;
        for rule = active_rules_1.act'
            
            counter = counter + 1;

            Distances = distance_from_vector( angle_list(angle), critic(rule).maximum_members , critic(rule).members );

            [~,select] = min(Distances);

            critic(rule).selected = select;

            actor_output_parameters(rule) = actor(rule).members (critic(rule).selected);
            
            C_select(counter) = select;
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
        

        %% reward calculation

        [reward_1 , reward_2] = reward_function (iteration , position_agent , position_goal , position_pit);

        %% Push data into replay buffer
        
        replay_buffer(2:buffer_size) = replay_buffer(1:buffer_size - 1);

        replay_buffer(1).s_1 = [position_agent(iteration , 1) , position_agent(iteration , 2) , position_agent(iteration , 3)];
        replay_buffer(1).s_2 = [position_agent(iteration+1 , 1) , position_agent(iteration+1 , 2) , position_agent(iteration+1 , 3)];

        replay_buffer(1).u = u.res;
        replay_buffer(1).up = up;

        replay_buffer(1).r_1 = reward_1;
        replay_buffer(1).r_2 = reward_2;

        replay_buffer(1).terminate = terminate;

        replay_buffer(1).select = C_select;

        replay_buffer(1).angle = angle;

        %% Trainer

        % if rp == buffer_size || mod(rp , 50) == 0
            matrix_G = G_extractor (critic , angle_list);
        % end

        % if rp >= buffer_size
            trainer;
        % end

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

        [Selected_particles , actor_weights] = G_test (critic , actor , angle_list);

        i=1;
        Fuzzy_actor.weights = actor_weights;
        algorithm_test (Fuzzy_actor , episode , gama_data , i);
        % animation_test (Fuzzy_actor ,critic , Selected_particles , gama_data );
        pareto_test (critic , actor , episode );

    end

end