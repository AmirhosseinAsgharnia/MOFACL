clear; clc

rng(125)
%%
figure;
set(gcf , "DefaultAxesFontName" , "times new roman");
set(gcf , "DefaultAxesFontSize" , 12);
set(gcf , "units" , "inches" , "pos" , [1 1 8 6])
set(gcf,'PaperUnits','Inches','PaperSize',[8 6])

%%
P = 10*randn(20,2);

plot(P(:,1),P(:,2),'*k'); hold on

origin = max(P);
%%
theta = pi/2;
theta_R = pi/6;

e_o = [ 1*cos(theta) ; 1*sin(theta)];
e_T = [-1*sin(theta) ; 1*cos(theta)];

R = [cos(-theta_R ) -sin(-theta_R );
     sin(-theta_R ) cos(-theta_R )];

R_passive = [cos(theta-theta_R ) sin(theta-theta_R );
            -sin(theta-theta_R ) cos(theta-theta_R )];

e_o_R =  R * e_o;
e_T_R =  R * e_T;

quiver(origin(1) , origin(2) , 10*e_o_R(1) , 10*e_o_R(2) , 0 , 'g');
quiver(origin(1) , origin(2) , 10*e_T_R(1) , 10*e_T_R(2) , 0 , 'g');

quiver(origin(1) , origin(2) , 10*e_o(1) , 10*e_o(2) , 0 , 'b');
quiver(origin(1) , origin(2) , 10*e_T(1) , 10*e_T(2) , 0 , 'b');

axis("equal")
grid minor

xlabel("X" , "Interpreter" , "latex")
ylabel("Y" , "Interpreter" , "latex")
%%

V_S1 = P - origin;
V_S2 =  R_passive * V_S1';

D = abs(V_S2(2,:));

f = find(D == min(D));

plot(P(f,1) , P(f,2) ,'*r')