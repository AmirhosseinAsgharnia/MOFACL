function [reward_1 , reward_2] = reward_function (iteration , position_agent , position_goal , position_pit)

reward_1 = distance_real (position_agent (iteration , 1:2) , position_goal) - distance_real (position_agent (iteration + 1 , 1:2) , position_goal);

reward_2 = distance_real (position_agent (iteration + 1 , 1:2) , position_pit) - distance_real (position_agent (iteration , 1:2) , position_pit);

% sigma_dist = 1;
% 
% mu_1 = 0.5;
% mu_2 = -0.5;
% 
% reward_1 = sign(reward_1_r)*(1/(sqrt(2*pi*sigma_dist^2))) * exp(-((reward_1_r-mu_1).^2)/(2*sigma_dist^2));
% 
% reward_2 = sign(reward_2_r)*(1/(sqrt(2*pi*sigma_dist^2))) * exp(-((reward_2_r-mu_2).^2)/(2*sigma_dist^2));

% reward_1 = sign(reward_1_r)*(1) * exp(-((reward_1_r-mu_1).^2));
% 
% reward_2 = sign(reward_2_r)*(1) * exp(-((reward_2_r-mu_2).^2));