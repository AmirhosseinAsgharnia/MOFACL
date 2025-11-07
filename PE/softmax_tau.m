% function p = softmax_tau (x)
% 
% tau_opt = 5;
% 
% z = (x + 2 * abs(min(x)) + 0.01) / (sum(x + 2 * abs(min(x)) + 0.01));
% 
% p = exp(tau_opt * z) / sum(exp(tau_opt * z));

function p = softmax_tau(x)
    tau_opt = 20;  % temperature parameter

    % Shift to avoid negatives (optional if you just flip sign)
    shift_x = x + 2 * abs(min(x)) + 0.01;
    z = shift_x / sum(shift_x);   % normalized to sum=1

    % Invert to give smaller x more weight
    exp_z = exp(-tau_opt * z);    % <-- negative sign here
    p = exp_z ./ sum(exp_z);
end