function ionizedImpurityScatteringRate(obj, es, pc)
    %>生成电离杂质散射句柄函数(弹性)
    qD = real(sqrt(pc.e^2*es.devDop / (pc.epsilon0*pc.epsilonL*pc.kb*es.devTem)));
    obj.ionizedImpurity = sqrt(2)*pc.e^4*es.devDop*obj.md^(3/2) ...
                                / (pi*(pc.epsilon0*pc.epsilonL)^2*pc.hbar^4) ...
                                * real(sqrt(es.gamma))*(1 + 2*es.epsilon/pc.e*obj.alpha) ...
                                / (qD^2*(qD^2 + 8*obj.md*es.gamma/pc.hbar^2))*obj.xsForimpurity;
    beta = real(sqrt(4*pi^2*pc.e^2*es.devDop/(pc.epsilonL*pc.epsilon0*pc.kb*es.devTem)));
    epsilonBeta1 = pc.hbar^2*beta^2/(2*obj.md);
    r = rand(1);
    obj.thetaIImpu = acos(1 - 2*(1-r)/(1+4*r*es.gamma/epsilonBeta1));
end