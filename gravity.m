% gravity
% computes the gravitational effect of a prism
% with density rho

function [g] = gravity(prism, rho)

% not considering that s_m is -1 if center of mass of polygon is above
% computational point. not necesary for modelling on surface only
s_m = 1;
gamma = 6.67384*10^-11;


sum = 0;
for i=(1):(length(prism.x)-1)

    if (i == length(prism(1).x)) % get back to the first corner when at end
        k = 1;
    else
        k = i+1;
    end

    x_1 = prism.x(i);
    x_2 = prism.x(k);
    dx = x_2-x_1;
    y_1 = prism.y(i);
    y_2 = prism.y(k);
    dy = y_2-y_1;
    z_1 = prism.z1;
    z_2 = prism.z2;

    ds = sqrt(dx^2 + dy^2);

    r_1 = sqrt(x_1^2 + y_1^2 );
    r_2 = sqrt(x_2^2 + y_2^2 );

    C_1 = -(x_1*dx + y_1*dy) / (r_1 * ds);
    C_2 = -(x_2*dx + y_2*dy) / (r_2 * ds);

    d_1 = -r_1 * C_1;
    d_2 = -r_2 * C_2;

    P = (x_1*y_2 - x_2*y_1)/ds;



    
    A = acos((x_1*x_2 + y_1*y_2) / (r_1*r_2));

    R11 = sqrt(r_1^2 + z_1^2);
    R12 = sqrt(r_1^2 + z_2^2);
    R21 = sqrt(r_2^2 + z_1^2);
    R22 = sqrt(r_2^2 + z_2^2);

    %%%%%%%%%%%%%%%%%%%%


    if (P>0)
        s_p = 1;
    else
        s_p = -1;
    end
    if (P == 0)
        s_p = 0;
    end


    sum = sum + s_p * A * (z_2 - z_1) + z_2*(atan((z_2*d_1)/(P*R12)) - atan((z_2*d_2)/(P*R22))) ...
        -z_1*(atan((z_1*d_1)/(P*R11)) - atan((z_1*d_2)/(P*R21))) - P * log( ((R22+d_2)/(R12+d_1)) * ((R11+d_1)/(R21+d_2)) );

end
g = -gamma * rho * s_m * sum;


end
