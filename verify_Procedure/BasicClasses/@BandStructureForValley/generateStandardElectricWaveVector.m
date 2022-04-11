function [k] = generateStandardElectricWaveVector(obj, es, pc, theta)
    %>根据能量选择电子波矢
    es.epsilon = es.energy - obj.Eg;
    es.gamma = es.epsilon*(1 + obj.alpha*es.epsilon/pc.e);
    kStarMold = sqrt(2*pc.m*es.gamma) / pc.hbar;
    %>球空间随机选择波矢
    phi = randNumber(0, 2*pi);
    kxStar = kStarMold * sin(theta) * cos(phi);
    kyStar = kStarMold * sin(theta) * sin(phi);
    kzStar = kStarMold * cos(theta);
    kStar = [kxStar, kyStar, kzStar]';
    k = (obj.invTz * kStar)';
end