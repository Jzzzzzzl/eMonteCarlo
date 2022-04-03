function ionizedImpurityScatteringRate(obj, dv, pc, cc)
    %>生成电离杂质散射句柄函数(弹性)
    %>     参数说明：
    %>     n：某位置掺杂浓度
    % ======================================================================
    n = cc.dopDensity;
    qD = sqrt(pc.e^2*n / (pc.epsilon0*pc.epsilonL*pc.kb*cc.envTemp));
    obj.ionizedImpurity = sqrt(2)*pc.e^4*n*dv.bs.md^(3/2) ...
                                / (pi*(pc.epsilon0*pc.epsilonL)^2*pc.hbar^4) ...
                                * real(sqrt(dv.bs.gamma))*(1 + 2*dv.bs.epsilon/pc.e*dv.bs.alpha) ...
                                / (qD^2*(qD^2 + 8*dv.bs.md*dv.bs.gamma/pc.hbar^2))*obj.xsForimpurity;
    beta = sqrt(4*pi^2*pc.e^2*n/(pc.epsilonL*pc.epsilon0*pc.kb*cc.envTemp));
    epsilonBeta = pc.hbar^2*beta^2/(2*pc.m);
    obj.thetaII = acos(1 - 2*(1-rand)/(1+4*rand*dv.bs.gamma/epsilonBeta));
end