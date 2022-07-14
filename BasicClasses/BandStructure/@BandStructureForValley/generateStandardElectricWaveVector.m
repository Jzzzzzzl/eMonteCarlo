function [k] = generateStandardElectricWaveVector(obj, es, pc)
    %>根据能量选择电子波矢
    es.epsilon = es.energy - obj.Eg;
    es.gamma = es.epsilon*(1 + obj.alpha*es.epsilon/pc.e);
    kStarMold = sqrt(2*pc.m*es.gamma) / pc.hbar;
    %>计算电场反方向旋转矩阵，z分量的情况考虑不充分
    devField = es.devField;
    rtheta = atan(-devField(1) / devField(3));
    rphi = atan(devField(2) / devField(1));
    if isnan(rtheta)
        rtheta = pi/2;
    elseif rtheta == 0
        rtheta = sign(devField(3)) * pi/2 - pi/2;
    end
    rMatrix = rotateMatrix(rtheta, 'y');
    if isnan(rphi)
        rphi = 0;
    end
    rMatrix = rotateMatrix(rphi, 'z') * rMatrix;
    %>球空间随机选择波矢
    phi = randNumber(0, 2*pi);
    kxStar = kStarMold * sin(es.theta) * cos(phi);
    kyStar = kStarMold * sin(es.theta) * sin(phi);
    kzStar = kStarMold * cos(es.theta);
    kStar = rMatrix * [kxStar, kyStar, kzStar]';
    k = (obj.invTz * kStar)';
end