function [S,R_x,R_y] = kronecker_sum (A , B , origin , angle_list)

S = zeros (size(A , 1) * size(B , 1) , size(A , 2));

R_x = zeros (size(A , 1) * size(B , 1) , size(A , 2));

R_y = zeros (size(A , 1) * size(B , 1) , size(A , 2));

counter = 1;

for i = 1 : size(A , 1)
    
    for j = 1 : size(B , 1)
        
        S(counter , :) = A(i , :) + B(j , :);
        
        [R_x(counter) , R_y(counter)] =...
            delta_direction_calculator(angle_list(j) , origin , A(i , :) , S(counter , :));

        counter = counter + 1;

    end

end