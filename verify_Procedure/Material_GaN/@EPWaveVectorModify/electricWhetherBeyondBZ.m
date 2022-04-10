function [bool] = electricWhetherBeyondBZ(k, pc)
    %>判断电子波矢是否超出第一布里渊区
    k = abs(k);
    situ1 = k(2) > pc.dGM;
    
    x = k(2)*pc.dGK / (sqrt(3)*k(1) + k(2));
    dxy = real(sqrt(pc.dGK^2 + 4*x^2 - 2*x*pc.dGK));
    kxy = sqrt(k(1)^2 + k(2)^2);
    situ2 = k(1) > pc.dGK/2 & kxy > dxy;
    
    situ3 = k(3) > pc.dGA;
    
    bool = situ1 || situ2 || situ3;
end