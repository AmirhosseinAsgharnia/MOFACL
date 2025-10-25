function [sort_order, crowding_distance] = CDE(G)
% G: n x 2 matrix (n solutions, 2 objectives)
% Output:
%   sort_order: index vector such that G(sort_order,:) is sorted by crowding distance (desc)
%   crowding_distance: vector of crowding distances for each solution

    [n, m] = size(G);
    if m ~= 2
        error('Function only supports bi-objective inputs (2 columns).');
    end

    % Initialize crowding distances
    crowding_distance = zeros(n,1);

    % Normalize each objective to [0,1]
    G_min = min(G);
    G_max = max(G);
    G_norm = (G - G_min) ./ (G_max - G_min + eps); % Avoid division by 0

    % For each objective
    for i = 1:m
        [~, idx] = sort(G_norm(:,i));
        crowding_distance(idx(1)) = inf;
        crowding_distance(idx(end)) = inf;

        for j = 2:n-1
            crowding_distance(idx(j)) = crowding_distance(idx(j)) + ...
                (G_norm(idx(j+1),i) - G_norm(idx(j-1),i));
        end
    end

    % Sort by descending crowding distance
    [~, sort_order] = sort(crowding_distance, 'descend');
    crowding_distance = crowding_distance(sort_order);
end
