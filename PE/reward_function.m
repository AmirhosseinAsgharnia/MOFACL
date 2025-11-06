function [reward_1 , reward_2] = reward_function (iteration , position_agent , position_goal , position_pit)

% sigmoid = @(x) 2*(1 / (1+exp(-x*6))-0.5);

reward_1 = 2*(distance_real (position_agent (iteration , 1:2) , position_goal) - distance_real (position_agent (iteration + 1 , 1:2) , position_goal));

reward_2 = 2*(distance_real (position_agent (iteration + 1 , 1:2) , position_pit) - distance_real (position_agent (iteration , 1:2) , position_pit));