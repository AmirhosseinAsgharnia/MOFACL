function ind = dominate(x,y)

% ind = all(x>=y) & any(x>y);

ind = sum(x>=y,2)==2 & sum(x>y,2)>=1;

% A=x>=y; B=x>y;
% ind=A(:,1)+A(:,2)==2 & B(:,1)+B(:,2)>=1; 

