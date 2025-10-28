clear;

%%

speed = 5;

position_agent = zeros(2,3);

up = -0.2;

position_agent(1 , :) = [0.5426    2.5250   -0.3270];

p = ode4(@(t , y) agent(t , y , up , speed) , [0 0.1] , position_agent(1 , :));

position_agent(2 , :) = p(end , :);

position_agent(2 , 3) = ang_adj(position_agent(2 , 3));