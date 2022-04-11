function [value] = whichValley(es)
    %>计算电子所在能谷标号
    absValley = abs(es.valley);
    if absValley <= 6
        axy = es.vector;
        flagy = axy(2) / abs(axy(2));%可能会有除0错误
        flagz = axy(3) / abs(axy(3));
        alpha = flagy*(acos(axy(1)/sqrt(sum(axy.^2))) - 2*pi * real(sqrt(-flagy)));
        value = flagz*(floor(alpha/(pi/3))+1);
    elseif absValley == 11
        value = 11;
    elseif absValley == 13
        value = 13;
    else
        disp(es)
        error("能谷标号错误！")
    end
end