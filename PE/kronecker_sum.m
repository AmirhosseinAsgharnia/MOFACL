function S = kronecker_sum (A , B)

S = zeros (size(A , 1) * size(B , 1) , size(A , 2));

counter = 1;

for i = 1 : size(A , 1)
    
    for j = 1 : size(B , 1)
        
        S(counter , :) = A(i , :) + B(j , :);

        counter = counter + 1;

    end

end