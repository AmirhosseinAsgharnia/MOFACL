function [mag, dir_vec, sign_proj] = proj_on_angle(Delta, angle)
% Projects a 2D vector Delta onto a line with slope given by angle (radians)
% Returns:
%   mag        - magnitude of the projection (always >= 0)
%   dir_vec    - unit direction vector of the line
%   sign_proj  - +1 if projection is in same direction, -1 if opposite, 0 if orthogonal

    % Unit vector along the line
    dir_vec = [cos(angle), sin(angle)];

    % Signed projection (dot product)
    proj_val = dot(Delta, dir_vec);

    % Magnitude (absolute value of projection)
    mag = abs(proj_val);

    % Sign of projection
    if proj_val > 0
        sign_proj = 1;
    elseif proj_val < 0
        sign_proj = -1;
    else
        sign_proj = 0;
    end
end