function [energy] = maxwellDistribution(pc, cc)
    %>拒绝算法生成电子初始能量
    dopDensity = max(max(cc.dopDensity.data));
    devTemp = 300;
    f = @(v) dopDensity * (pc.m/(2*pi*pc.kb*devTemp))^(3/2) * ...
                exp(-pc.m*v.^2/(2*pc.kb*devTemp));
    fMax = f(0);
    fx = 0;
    fc = 1;
    
    while fx <= fc
        fc = fMax * rand;
        velocity = rand * pc.maxVelocity;
        fx = f(velocity);
    end
    
    energy = 0.5 * pc.m * velocity^2 + cc.initEnergy;
end