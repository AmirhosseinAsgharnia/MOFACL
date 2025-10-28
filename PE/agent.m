function dy=agent(t,y,U,v)

%% differential equations

dy = zeros(3,1);

dy(1) = v * cos(y(3));
dy(2) = v * sin(y(3));
dy(3) = v * tan(U) / 0.3;