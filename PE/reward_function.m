function [reward_1_r , reward_2_r] = reward_function (iteration , position_agent , position_goal , position_pit)

reward_1 = 2*(distance_real (position_agent (iteration , 1:2) , position_goal) - distance_real (position_agent (iteration + 1 , 1:2) , position_goal));

reward_2 = 2*(distance_real (position_agent (iteration + 1 , 1:2) , position_pit) - distance_real (position_agent (iteration , 1:2) , position_pit));

reward_1_r = sign(reward_1) * tan(reward_1^2)/tan(1);
reward_2_r = sign(reward_2) * tan(reward_2^2)/tan(1);