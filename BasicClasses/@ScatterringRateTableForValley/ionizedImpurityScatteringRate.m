function ionizedImpurityScatteringRate(obj, es, pc, cc)
    %>生成电离杂质散射句柄函数(弹性)
    %>     参数说明：
    %>     n：某位置掺杂浓度
    % ======================================================================
    try
        n = cc.computeDopingDensity(es);
    catch
        n = max(max(cc.dopDensity.data));
    end
    qD = sqrt(pc.e^2*n / (pc.epsilon0*pc.epsilonL*pc.kb*cc.envTemp));
    obj.ionizedImpurity = sqrt(2)*pc.e^4*n*obj.md^(3/2) ...
                                / (pi*(pc.epsilon0*pc.epsilonL)^2*pc.hbar^4) ...
                                * real(sqrt(es.gamma))*(1 + 2*es.epsilon/pc.e*obj.alpha) ...
                                / (qD^2*(qD^2 + 8*obj.md*es.gamma/pc.hbar^2))*obj.xsForimpurity;
    beta = real(sqrt(4*pi^2*pc.e^2*n/(pc.epsilonL*pc.epsilon0*pc.kb*cc.envTemp)));
    epsilonBeta1 = pc.hbar^2*beta^2/(2*obj.md);
    obj.thetaII = acos(1 - 2*(1-rand)/(1+4*rand*es.gamma/epsilonBeta1));
end