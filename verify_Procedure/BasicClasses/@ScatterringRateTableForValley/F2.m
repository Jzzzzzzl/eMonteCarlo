function [value] = F2(~, x)
    %> 电子谷内散射积分函数F2
    xabar = 3.5;
    
    if x <= xabar
        value = x^3/3 - x^4/8 + x^5/60 - x^7/5040;
    else
        value = xabar^3/3 - xabar^4/8 + xabar^5/60 - xabar^7/5040 ...
                + exp(-xabar)*(xabar^3 + 3*xabar^2 + 6*xabar + 6) ...
                - exp(-x)*(x^3 + 3*x^2 + 6*x + 6);
    end
end
