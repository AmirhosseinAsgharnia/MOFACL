function c1 = proj_compare(critic1, angle, origin)
% critic1, critic2: 1x2 vectors (bi-objective points)
% angle: direction of the line in radians (0..pi/2)
% origin: either
%   - 1x2 point that lies on the line  (recommended), OR
%   - scalar bias "b" for y = tan(angle)*x + b   (legacy; see below)

    % Unit direction vector along the line
    d = [cos(angle), sin(angle)];   % if you actually mean slope m, see alt below

    if isscalar(origin)
        % Legacy "bias" mode: treat mapping as dot(d, p) + b
        c1 = dot(d, critic1) + origin;
    else
        % Point-on-line mode: parameterize line as origin + t*d and get t
        c1 = dot(d, critic1 - origin);
    end

end
