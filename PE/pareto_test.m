function pareto_test (critic , actor , episode )

Rules = [197 204 205 212 213 220 221 228 187];

fig = figure('Visible','off');

set(fig, ...
    'Units',        'inches', ...
    'Position',     [0 0 7 6], ...
    'PaperUnits',   'inches', ...
    'PaperPosition',[0 0 7 6] ...
    );

set(fig,'defaultaxesfontsize',6)
set(fig,'defaulttextfontsize',3)

set(fig,'defaultaxesfontname',"times new roman")
set(fig,'defaulttextfontname',"times new roman")

counter = 0;

for rule = Rules

    counter = counter + 1;

    subplot(3 , 3 , counter)

    plot(critic(rule).members(:,1),critic(rule).members(:,2),'*b'); hold on
    plot(critic(rule).pareto(:,1),critic(rule).pareto(:,2),'*k')
    plot(critic(rule).minimum_members(1),critic(rule).minimum_members(2),'*g')
    title(sprintf("Rule: %d",Rules(counter)))

    for member = 1:numel(critic(rule).pareto) / 2

        text(critic(rule).pareto(member,1) , critic(rule).pareto(member,2) , ...
            sprintf("\\leftarrow \\omega = %.2f" , actor(rule).pareto(member)));

    end
    
    grid minor

    xlim([-3  2])
    ylim([-3  2])
end



print(fig, sprintf('Figs/Rules_%d.png',episode), '-dpng', '-r300');

close(fig)
