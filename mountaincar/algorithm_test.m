function algorithm_test (Fuzzy_actor , episode ,i)

filename = sprintf('./animation/epoch_%d_%d.gif', episode,i); % output file

max_iteration = 999;

fig = figure('Visible','off');

set(fig, ...
    'Units',        'inches', ...
    'Position',     [0 0 3 3], ...
    'PaperUnits',   'inches', ...
    'PaperPosition',[0 0 3 3] ...
    );

x = -1.2:0.01:0.6;
y = cos (2 * pi * (x + 1.45) / 1.9);

plot(x,y,'-k');

grid minor
terminate = 0;
iteration= 0;

observation = zeros (max_iteration , 2);

observation (1 , :) = [0.2 * rand - 0.6 , 0];
y = cos (2 * pi * (observation(1 , 1) + 1.45) / 1.9);

ret = rectangle('Position', [observation(1,1)-0.05 y-0.05 0.1 0.1], 'FaceColor', 'red', 'EdgeColor', 'black');
counter = 0;

y = zeros(5,1);
x = zeros(5,1);

while ~terminate && iteration < max_iteration

    iteration = iteration + 1;

    u = fuzzy_engine_2 ([observation(iteration , 1) , observation(iteration , 2)] , Fuzzy_actor);

    %% taking action

    [observation(iteration + 1 , 1) , observation(iteration + 1 , 2) , ~ , ~ , terminate] = ...
        agent (observation(iteration , 1) , observation(iteration , 2) , u.res);

    if mod(iteration , 3) == 0 || iteration == 1 || terminate == 1
        counter = counter + 1;
        x(counter) = observation(iteration + 1 , 1);
        y(counter) = cos (2 * pi * (observation(iteration + 1 , 1) + 1.45) / 1.9);
    end

end

for counter = 1:numel(x) 

    delete(ret)
    ret = rectangle('Position', [x(counter)-0.05 y(counter)-0.05 0.1 0.1], 'FaceColor', 'red', 'EdgeColor', 'black');
    xlim([-1.2 0.6]); ylim([-1.2 1.2])

    if terminate == 1
        title(sprintf("Therminated at %d iterations.",iteration))
    else
        title(sprintf("Game not terminated!"))
    end

    frame = getframe(gcf);
    im = frame2im(frame);
    [imind,cm] = rgb2ind(im,256);

    if counter == 1
        imwrite(imind,cm,filename,'gif','Loopcount',inf,'DelayTime',0.1);
    else
        imwrite(imind,cm,filename,'gif','WriteMode','append','DelayTime',0.1);
    end
end

close(fig)