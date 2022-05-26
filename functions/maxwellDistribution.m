function [energy] = maxwellDistribution(pc, cc)
    %>拒绝算法生成电子动能
    dopDensity = max(max(cc.dopDensity.data));
    f = @(v) dopDensity * (pc.m/(2*pi*pc.kb*cc.initTemp))^(3/2) * ...
                exp(-pc.m*v.^2/(2*pc.kb*cc.initTemp));
    fMax = f(0);
    fx = 0;
    fc = 1;
    
    while fx <= fc
        fc = fMax * rand;
        velocity = rand * pc.maxVelocity;
        fx = f(velocity);
    end
    
    energy = 0.5 * pc.m * velocity^2;
end