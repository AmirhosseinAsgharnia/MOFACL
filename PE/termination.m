function terminate = termination (iteration , capture_radius , position_agent , position_goal , position_pit)

if distance_real(position_agent(iteration + 1 , 1:2) , position_goal) < capture_radius
    
    terminate = 1;

elseif distance_real(position_agent(iteration + 1 , 1:2) , position_pit) < capture_radius

    terminate = 2;

else

    terminate = 0;

end