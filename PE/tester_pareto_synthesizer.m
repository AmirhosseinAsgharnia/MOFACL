clear; clc
rng(124)

%%

max_repo_member = 100;
rule = 1;

%%

critic.members = rand(100 , 2);
critic.crowding_distance = zeros(100 , 1);
critic.index   = zeros(100 , 1);
critic.label   = (1:100)';
critic.pareto  = zeros(100 , 1);

actor.members = (1:100)';

%%

[critic_2 , actor_2] = pareto_synthesizer (critic , actor , rule , max_repo_member);

%%

