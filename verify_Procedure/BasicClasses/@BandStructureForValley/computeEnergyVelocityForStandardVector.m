function [energy, velocity] = computeEnergyVelocityForStandardVector(obj, k, pc)
    %>计算电子能量
    obj.epsilon = pc.hbar^2*(k(1)^2 / obj.mt + k(2)^2 / obj.mt + k(3)^2 / obj.ml) / 2;
    energy = obj.epsilon * (1 + obj.epsilon/pc.e * obj.alpha) + obj.Eg;
    %>计算电子速度
    kStar = obj.Tz * k';
    vStar = pc.hbar * kStar / (pc.m * (1 + 2*obj.alpha*obj.epsilon/pc.e));
    velocity = (obj.invTz * vStar)';
end