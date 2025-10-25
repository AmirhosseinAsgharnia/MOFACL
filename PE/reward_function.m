function [reward_1 , reward_2] = reward_function (iteration , position_agent , position_goal , position_pit)

reward_1 = distance_real (position_agent (iteration , 1:2) , position_goal) - distance_real (position_agent (iteration + 1 , 1:2) , position_goal);

reward_2 = distance_real (position_agent (iteration + 1 , 1:2) , position_pit) - distance_real (position_agent (iteration , 1:2) , position_pit);