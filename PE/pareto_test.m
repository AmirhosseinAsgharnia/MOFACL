function pareto_test (critic , actor , episode )

Rules = [51 71];

fig = figure('Visible','off');

set(fig, ...
    'Units',        'inches', ...
    'Position',     [0 0 6 2.2], ...
    'PaperUnits',   'inches', ...
    'PaperPosition',[0 0 6 2.2] ...
    );

set(fig,'defaultaxesfontsize',4)
set(fig,'defaulttextfontsize',4)

counter = 0;

for rule = Rules

    counter = counter + 1;
    subplot(1 , 2 , counter)
    plot(critic(rule).members(:,1),critic(rule).members(:,2),'*b'); hold on
    plot(critic(rule).pareto(:,1),critic(rule).pareto(:,2),'*k')
    plot(critic(rule).minimum_members(1),critic(rule).minimum_members(2),'*g')
    for member = 1:numel(critic(rule).pareto) / 2

        text(critic(rule).pareto(member,1) , critic(rule).pareto(member,2) , ...
            sprintf("\\leftarrow w = %.2f" , actor(rule).pareto(member)));

    end
    
    grid minor

    xlim([-1 1])
    ylim([-1 1])
end



print(fig, sprintf('Figs/Rules_%d.png',episode), '-dpng', '-r300');

close(fig)
