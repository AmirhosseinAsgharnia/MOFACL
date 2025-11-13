function D = distance_from_vector(theta_R , origin , V )

theta = pi/2;

R_passive = [cos(theta - theta_R) sin(theta - theta_R);
            -sin(theta - theta_R) cos(theta - theta_R)];

V_S1 = V' - origin';
V_S2 =  R_passive * V_S1;

D = abs(V_S2(2,:));