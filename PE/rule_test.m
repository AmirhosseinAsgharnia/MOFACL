clear; clc

%%

load("policy")

rule=51;
close all

figure
angle=1;
for i = 1:size(critic(51).members,1)

    plot(critic(rule).members(i,1),critic(rule).members(i,2),'*r')
    hold on

    text(critic(rule).members(i,1),critic(rule).members(i,2),sprintf("\\leftarrow angle: %.2f",critic(51).index(i)))

end

plot(critic(rule).minimum_members(1),critic(rule).minimum_members(2) , 'or','MarkerFaceColor', 'r')
% plot(critic(51).minimum_pareto(1),critic(51).minimum_pareto(2) , 'ob','MarkerFaceColor', 'b')

x_l    = zeros(2,1);
x_l(1) = critic(rule).minimum_members(1);
x_l(2) = 1;

y_l    = zeros(2,1);
y_l(1) = critic(rule).minimum_members(2);
y_l(2) = critic(rule).minimum_members(2) + tan(angle_list(angle))*(1 - critic(rule).minimum_members(1));

plot(x_l,y_l,'--k')
title(sprintf("$$angle: %.2f$$",angle_list(angle)),'Interpreter','latex')

xlim([min(critic(rule).members(:,1)) max(critic(rule).members(:,1))])
ylim([min(critic(rule).members(:,2)) max(critic(rule).members(:,2))])
grid minor

[~ , so] = sort (critic(rule).index);

disp([critic(rule).index(so) critic(rule).members(so,:) actor(rule).members(so)])