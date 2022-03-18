function [value] = G2(~, x)
    %> 电子谷内散射积分函数G2
    xebar = 4;
    
    if x <= xebar
        value = x^3/3 + x^4/8 + x^5/60 - x^7/5040;
    else
        value = xebar^3/3 + xebar^4/8 + xebar^5/60 - xebar^7/5040 ...
                + exp(-xebar)*(xebar^3 + 3*xebar^2 + 6*xebar + 6) - xebar^4/4 ...
                - exp(-x)*(x^3 + 3*x^2 + 6*x + 6) + x^4/4;
    end
end
