function [position , velocity , reward_1 , reward_2 , terminate] = agent (position , velocity , force)

velocity = velocity + force * 0.0015 - 0.0025 * cos (3 * position);

velocity = max(velocity , - 0.07);

velocity = min(velocity , 0.07);

position = position + velocity;

position = max(position , - 1.2);

position = min(position , 0.6);

reward_1 = - 0.1 * force^2;

if position >= 0.45

    reward_2 = 0;
    terminate = 1;
    
else

    reward_2 = -1;
    terminate = 0;
    
end

