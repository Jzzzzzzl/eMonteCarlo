function [energy] = maxwellDistribution(pc, cc)
    %拒绝算法生成电子动能
    f = @(v) cc.dopDensity * (pc.m/(2*pi*pc.kb*cc.envTemp))^(3/2) * ...
                exp(-pc.m*v.^2/(2*pc.kb*cc.envTemp));
    fMax = f(0);
    fx = 0;
    fc = 1;
    
    while fx <= fc
        fc = fMax * rand;
        velocity = rand * cc.maxVelocity;
        fx = f(velocity);
    end
    
    energy = 0.5 * pc.m * velocity^2;
end