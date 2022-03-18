function [value] = G1(~, x)
    %> 电子谷内散射积分函数G1
    xebar = 4;
    
    if x <= xebar
        value = x^2/2 + x^3/6 + x^6/4320;
    else
        value = xebar^2/2 + xebar^3/6 + xebar^4/48 - xebar^6/4320 ...
                + exp(-xebar)*(xebar^2 + 2*xebar + 2) - xebar^3/3 ...
                - exp(-x)*(x^2 + 2*x + 2) + x^3/3;
    end
end
