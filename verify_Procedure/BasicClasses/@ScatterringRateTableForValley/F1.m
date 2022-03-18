function [value] = F1(~, x)
    %> 电子谷内散射积分函数F1
    xabar = 3.5;
    
    if x <= xabar
        value = x^2/2 - x^3/6 + x^4/48 - x^6/4320;
    else
        value = xabar^2/2 - xabar^3/6 + xabar^4/48 - xabar^6/4320 ...
                + exp(-xabar)*(xabar^2 + 2*xabar + 2) ...
                - exp(-x)*(x^2 + 2*x + 2);
    end
end
