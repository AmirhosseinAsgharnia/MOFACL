function algorithm_test (Fuzzy_actor , critic , Selected_particles , episode , gama_data , number)

fig_anim = figure;

set(fig_anim, ...
    'Units',        'inches', ...
    'Position',     [0.1 1 14 8], ...
    'PaperUnits',   'inches', ...
    'PaperPosition',[0 0 14 8] ...
    );

set(fig_anim,'defaultaxesfontsize',10)
set(fig_anim,'defaulttextfontsize',10)

fig = figure('Visible','off');

set(fig, ...
    'Units',        'inches', ...
    'Position',     [0 0 7 4], ...
    'PaperUnits',   'inches', ...
    'PaperPosition',[0 0 7 4] ...
    );

set(fig,'defaultaxesfontsize',4)
set(fig,'defaulttextfontsize',4)
Fuzzy_actor_s = Fuzzy_actor;


for num = 1:5

    Fuzzy_actor_s.weights = Fuzzy_actor.weights(: , num);

    max_iteration = 200;

    step_time = 0.1;

    capture_radius = 3;

    position_agent = zeros (max_iteration , 3);

    position_agent (1 , :) = [0 , 0 , pi/4];

    iteration = 0;

    terminate = 0;

    used_rule = zeros (max_iteration , 1);

    while ~terminate && iteration < max_iteration

        iteration = iteration + 1;

        %% input calculator

        u = fuzzy_engine_3 ([position_agent(iteration , 1) , position_agent(iteration , 2) , position_agent(iteration , 3)] , Fuzzy_actor_s);
        u_phi = [u.act u.phi];
        [~ , max_phi] = max( u_phi(:,2) );
        used_rule(iteration) = u.act(max_phi);

        %%

        p = ode4(@(t , y) agent(t , y , u.res , gama_data.speed) , [0 step_time] , position_agent(iteration , :));

        position_agent(iteration + 1 , :) = p(end , :);

        position_agent(iteration + 1 , 3) = ang_adj(position_agent(iteration + 1 , 3));

        position_agent = border(position_agent , iteration);

        terminate = termination (iteration , capture_radius , position_agent , gama_data.position_goal , gama_data.position_pit);

        if num==3
            figure(fig_anim)
            if iteration == 1

                subplot(2,5,1)
                plot(gama_data.position_goal(1) + capture_radius * cos(0:0.1:2*pi) , gama_data.position_goal(2) + capture_radius * sin(0:0.1:2*pi) , '-g')
                hold on
                plot(gama_data.position_pit(1) + capture_radius * cos(0:0.1:2*pi) , gama_data.position_pit(2) + capture_radius * sin(0:0.1:2*pi) , '-r')
                plot([0 0 50 50 0] , [0 50 50 0 0], '--k')
                xlim([-10 60])
                ylim([-10 60])
                grid minor
                drawnow

            end

            subplot(2,5,1)
            plot(position_agent(iteration+1 , 1) , position_agent(iteration+1 , 2) , ".r"); hold on
            drawnow
            if iteration~=1
                
                S = find(u.phi > 0.2);
                for j = 1:numel(S)
                    subplot(2,5,j+5)
                    
                    plot(critic(u.act(j)).members(:,1) , critic(u.act(j)).members(:,2) , "*k")
                    hold on

                    plot(critic(u.act(j)).pareto(:,1) , critic(u.act(j)).pareto(:,2) , "*b")
                    plot(critic(u.act(j)).pareto(Selected_particles(u.act(j),num),1) , critic(u.act(j)).pareto(Selected_particles(u.act(j),num),2),'*r')
                    hold off
                    drawnow

                    text(critic(u.act(j)).pareto(Selected_particles(u.act(j),num),1) , critic(u.act(j)).pareto(Selected_particles(u.act(j),num),2) , ...
                        sprintf("\\leftarrow \\omega = %.2f" , Fuzzy_actor.weights(u.act(j))));
                    title(sprintf("Rule %d: \\phi: %f" , u.act(j),u.phi(j)))
                end

            end
        end
    end

    figure(fig)
    set(fig,'Visible','off');

    if terminate == 1 || terminate == 2
        position_agent ( iteration + 2 : end , :) = [];
        used_rule( iteration + 1 : end) = [];
    end

    plot_color = [];

    n=1;
    for i = 1 : numel(used_rule)-1
        if used_rule(i) ~= used_rule(i+1)
            plot_color(n,:) = [i , used_rule(i)];
            n = n+1;
        end
    end

    plot_color(n,:) = [i+1 , used_rule(i+1)];

    subplot(2,3,num)

    plot([0 0 gama_data.dimension gama_data.dimension 0],[0 gama_data.dimension gama_data.dimension 0 0],'--k')
    hold on
    plot(gama_data.position_pit(1)+3*cos(-pi:0.1:pi),gama_data.position_pit(2)+3*sin(-pi:0.1:pi),'r')
    plot(gama_data.position_goal(1)+3*cos(-pi:0.1:pi),gama_data.position_goal(2)+3*sin(-pi:0.1:pi),'g')


    for i = 1:size(plot_color,1)
        if i == 1
            plot(position_agent(1 : plot_color(i),1) , position_agent(1 : plot_color(i),2))
        else
            plot(position_agent( plot_color(i-1) : plot_color(i),1) , position_agent( plot_color(i-1) : plot_color(i),2))
        end
        text(position_agent(plot_color(i),1) , position_agent(plot_color(i),2) , sprintf("\\leftarrow rule: %d",plot_color(i,2)))
    end

    xlim([-10 60]);
    ylim([-10 60]);

    grid on
    grid minor

end

print(fig, sprintf('Figs/Episode_%d_i_%d.png',episode,number), '-dpng', '-r300');

% After loop:
if exist('fig_anim','var') && isvalid(fig_anim)
    close(fig_anim)
end

if exist('fig','var') && isvalid(fig)
    close(fig)
end
