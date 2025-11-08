function [critic , actor] = pareto_synthesizer (critic , actor , rule , max_repo_member)

% critic_test = critic;

members = [critic(rule).members , (1:size(critic(rule).members , 1))'];

maximum_pareto_front = 0;

while ~isempty(members)
    
    maximum_pareto_front = maximum_pareto_front + 1;

    [~ , R] = ND_opt( members(: , 1:2) );

    critic(rule).index (members(R==0 , 3)) = maximum_pareto_front;

    members(R==0,:)=[];

end

%% Sorting

[critic(rule).index , sort_index] = sort(critic(rule).index);

critic(rule).members = critic(rule).members(sort_index , :);

% critic(rule).label = critic(rule).label(sort_index);

actor(rule).members  = actor(rule).members(sort_index);

for pareto_front = 1 : maximum_pareto_front

    member_index = find(critic(rule).index == pareto_front);

    members = critic(rule).members(member_index , :);
    
    members_actor = actor(rule).members(member_index);

    % label = critic(rule).label(member_index);

    [~ , sort_members] = sort(members(:,1));
    
    members = members (sort_members,:);
    
    members_actor = members_actor(sort_members);

    % label = label(sort_members);

    critic(rule).members(member_index , :) = members;    
    
    % critic(rule).label(member_index) = label;    

    actor(rule).members(member_index) = members_actor;
    %%

    crowding_distance = crowding_distance_eval (members);
    
    [~ , sort_index] = sort(crowding_distance , 'descend');

    critic(rule).crowding_distance(min(member_index):max(member_index)) = crowding_distance(sort_index);

    critic(rule).members(min(member_index):max(member_index),:) = members(sort_index,:);
    
    % critic(rule).label(min(member_index):max(member_index)) = label(sort_index);

    actor(rule).members(min(member_index):max(member_index)) = members_actor(sort_index);

end

if numel(actor(rule).members) > max_repo_member
    
    actor(rule).members = actor(rule).members(1:max_repo_member);
    critic(rule).members = critic(rule).members(1:max_repo_member,:);
    critic(rule).index = critic(rule).index(1:max_repo_member);
    % critic(rule).label = critic(rule).label(1:max_repo_member); % Added New
    critic(rule).crowding_distance = critic(rule).crowding_distance(1:max_repo_member);

end

pareto_index = find(critic(rule).index == 1);
critic(rule).pareto = critic(rule).members(pareto_index , :);
actor(rule).pareto = actor(rule).members(pareto_index);

%% Testing

% plot(critic(1).members(:,1) , critic(1).members(:,2) , "*r"); hold on
% 
% I1 = find(critic(1).index == 1);
% 
% plot(critic(1).members(I1,1) , critic(1).members(I1,2) , "*b")
% 
% I2 = find(critic(1).index == 2);
% 
% plot(critic(1).members(I2,1) , critic(1).members(I2,2) , "*g")
% 
% I3 = find(critic(1).index == 3);
% 
% plot(critic(1).members(I3,1) , critic(1).members(I3,2) , "*k")
% 
% I4 = find(critic(1).index == 5);
% 
% plot(critic(1).members(I4,1) , critic(1).members(I4,2) , "*y")
    
    

end