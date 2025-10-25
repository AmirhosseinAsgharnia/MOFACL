function [critic , actor] = nondominant_sorting(critic , actor , rule)

[critic(rule).pareto , R] = ND_opt (critic(rule).members);

actor(rule).pareto = actor(rule).members(R==0);

critic(rule).pareto_index = critic(rule).index(R==0);

%%

[~ , so] = sort (critic(rule).members(:,1) , 'descend');

critic(rule).members = critic(rule).members(so , :);

critic(rule).index = critic(rule).index(so , :);

actor(rule).members = actor(rule).members(so , :); 

%%

[~ , so] = sort (critic(rule).pareto(:,1) , 'descend');

critic(rule).pareto = critic(rule).pareto(so , :);

critic(rule).pareto_index = critic(rule).pareto_index(so , :);

actor(rule).pareto = actor(rule).pareto(so , :); 