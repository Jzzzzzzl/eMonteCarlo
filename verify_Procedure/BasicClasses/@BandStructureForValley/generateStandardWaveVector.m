function [k] = generateStandardWaveVector(obj, es, pc)
    %>根据能量选择电子波矢
    epsilonTemp = (sqrt(1 + 4*obj.alpha*(es.energy - obj.Eg)/pc.e) - 1) / (2*obj.alpha) * pc.e;
    kStarMold = sqrt(2 * pc.m * epsilonTemp) / pc.hbar;
    %>球空间随机选择波矢
    phi = randNumber(0, pi);
    theta = randNumber(0, 2*pi);
    kxStar = kStarMold * sin(phi) * cos(theta);
    kyStar = kStarMold * sin(phi) * sin(theta);
    kzStar = kStarMold * cos(phi);
    kStar = [kxStar, kyStar, kzStar]';
    k = (obj.invTz * kStar)';
end