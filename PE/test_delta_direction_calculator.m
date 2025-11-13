% function [R_x , R_y] = delta_direction_calculator(theta_R , origin , V1 , V2)
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
%%
theta = pi/2;
origin = max(P);

e_o = [ 1*cos(theta) ; 1*sin(theta)];
e_T = [-1*sin(theta) ; 1*cos(theta)];

quiver(origin(1) , origin(2) , 10*e_o(1) , 10*e_o(2) , 0 , 'b'); hold on
quiver(origin(1) , origin(2) , 10*e_T(1) , 10*e_T(2) , 0 , 'b');
%% Local System

theta_R = 0-pi/6;

R = [cos(theta_R) -sin(theta_R)
     sin(theta_R)  cos(theta_R)];

e_o_R =  R * e_o;
e_T_R =  R * e_T;

quiver(origin(1) , origin(2) , 10*e_o_R(1) , 10*e_o_R(2) , 0 , 'g');
quiver(origin(1) , origin(2) , 10*e_T_R(1) , 10*e_T_R(2) , 0 , 'g');

% Plotting
% xlim([-15 , 15])
% ylim([-15 , 15])
axis("equal")
grid minor

xlabel("X" , "Interpreter" , "latex")
ylabel("Y" , "Interpreter" , "latex")

%% 

% V1 = [ -5 , -5];
% V2 = [ -5 , -2 + 2*tand(30) ];

% R_passive = [cos(theta_R) sin(theta_R);
%             -sin(theta_R) cos(theta_R)];
% 
% V1_S1 = V1 - origin;
% V2_S1 = V2 - origin;
% 
% quiver(V1(1) , V1(2) , V2(1) - V1(1) , V2(2) - V1(2) , 0, 'r');
% plot(V1(1),V1(2),"xk")
% plot(V2(1),V2(2),"xk")
% 
% V1_S2 =  R_passive * V1_S1';
% V2_S2 =  R_passive * V2_S1';
% 
% %%
% 
% R_x = V2_S2(1) - V1_S2(1);
% R_y = abs(V1_S2(2)) - abs(V2_S2(2));