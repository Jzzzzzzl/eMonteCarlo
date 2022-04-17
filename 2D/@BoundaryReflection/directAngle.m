function [theta] = directAngle(x1, y1, x2, y2, x3, y3)
    %>返回以第一个点为顶点的夹角
    rou1 = sqrt((x3 - x2)^2 + (y3 - y2)^2);
    rou2 = sqrt((x3 - x1)^2 + (y3 - y1)^2);
    rou3 = sqrt((x1 - x2)^2 + (y1 - y2)^2);
    flag = true;
    try
        theta = real(acos((rou2^2 + rou3^2 - rou1^2) / (2*rou2*rou3)));
    catch
        flag = false;
    end
    if ~flag
        theta = pi;
    end
end