function animation_test(Fuzzy_actor , critic , Selected_particles  , gama_data)

%%
fig_anim = figure;

set(fig_anim, ...
    'Units',        'inches', ...
    'Position',     [0.1 1 8 8], ...
    'PaperUnits',   'inches', ...
    'PaperPosition',[0 0 14 8] ...
    );

set(fig_anim,'defaultaxesfontsize',10)
set(fig_anim,'defaulttextfontsize',10)

%%

Fuzzy_actor_s = Fuzzy_actor;

num = 3;

Fuzzy_actor_s.weights = Fuzzy_actor.weights(: , num);

max_iteration = 200;

step_time = 0.1;

capture_radius = 3;

position_agent = zeros (max_iteration , 3);

position_agent (1 , :) = [0 , 0 , pi/4];

iteration = 0;

terminate = 0;

figure(fig_anim)

while ~terminate && iteration < max_iteration

    iteration = iteration + 1;

    %% input calculator

    u = fuzzy_engine_3 ([position_agent(iteration , 1) , position_agent(iteration , 2) , position_agent(iteration , 3)] , Fuzzy_actor_s);

    %%

    p = ode4(@(t , y) agent(t , y , u.res , gama_data.speed) , [0 step_time] , position_agent(iteration , :));

    position_agent(iteration + 1 , :) = p(end , :);

    position_agent(iteration + 1 , 3) = ang_adj(position_agent(iteration + 1 , 3));

    position_agent = border(position_agent , iteration);

    terminate = termination (iteration , capture_radius , position_agent , gama_data.position_goal , gama_data.position_pit);

    if iteration == 1

        subplot(2,2,1)
        plot(gama_data.position_goal(1) + capture_radius * cos(0:0.1:2*pi) , gama_data.position_goal(2) + capture_radius * sin(0:0.1:2*pi) , '-g')
        hold on
        plot(gama_data.position_pit(1) + capture_radius * cos(0:0.1:2*pi) , gama_data.position_pit(2) + capture_radius * sin(0:0.1:2*pi) , '-r')
        plot([0 0 50 50 0] , [0 50 50 0 0], '--k')
        xlim([-10 60])
        ylim([-10 60])
        grid minor
        drawnow

    end

    subplot(2,2,1)

    plot(position_agent(iteration+1 , 1) , position_agent(iteration+1 , 2) , ".r"); hold on

    drawnow

    if iteration~=1
        
        [~,S] = sort(u.phi,'descend');
        S = S(1:3);
        for j = 1:numel(S)

            subplot(2,2,j+1)

            plot(critic(u.act(S(j))).members(:,1) , critic(u.act(S(j))).members(:,2) , "*k")
            hold on

            plot(critic(u.act(S(j))).pareto(:,1) , critic(u.act(S(j))).pareto(:,2) , "*b")
            plot(critic(u.act(S(j))).pareto(Selected_particles(u.act(S(j)),num),1) , critic(u.act(S(j))).pareto(Selected_particles(u.act(S(j)),num),2),'*r')
            hold off
            drawnow

            text(critic(u.act(S(j))).pareto(Selected_particles(u.act(S(j)),num),1) , critic(u.act(S(j))).pareto(Selected_particles(u.act(S(j)),num),2) , ...
                sprintf("\\leftarrow \\omega = %.2f" , Fuzzy_actor.weights(u.act(j))));
            title(sprintf("Rule %d: \\phi: %f" , u.act(j),u.phi(j)))

        end

    end

end




% After loop:
if exist('fig_anim','var') && isvalid(fig_anim)
    close(fig_anim)
end

