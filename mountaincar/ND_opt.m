function [Q_value,R] = ND_opt(Q_value)

n = size(Q_value,1);
R = zeros(n,1);

B = Q_value(:,1); C = Q_value(:,2);

for i=1:n
    ind_1 = dominate([B(i),C(i)],[B,C]);
    R(ind_1==1) = 1; 
    ind_2 = dominate([B,C],[B(i),C(i)]);
    if sum(ind_2)~=0
        R(i)=1;
    end
end

% R(B==C) = 1;

Q_value(R==1,:)=[];