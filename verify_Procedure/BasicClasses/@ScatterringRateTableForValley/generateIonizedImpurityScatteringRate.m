function generateIonizedImpurityScatteringRate(obj, dv, pc, cc)
    %>生成电离杂质散射句柄函数(弹性)
    %>     参数说明：
    %>     n：某位置掺杂浓度
    % ======================================================================
    n = cc.dopDensity;
    gamma = dv.bs.epsilon*(1 + dv.bs.epsilon/pc.e * dv.bs.alpha);
    qD = sqrt(pc.e^2*n / (pc.epsilon0*pc.epsilon*pc.kb*cc.envTemp));
    obj.ionizedImpurityScatRate = sqrt(2)*pc.e^4*n*dv.bs.md^(3/2) ...
                                            / (pi*(pc.epsilon0*pc.epsilon)^2*pc.hbar^4) ...
                                            * real(sqrt(gamma))*(1 + 2*dv.bs.epsilon/pc.e*dv.bs.alpha) ...
                                            / (qD^2*(qD^2 + 8*dv.bs.md*gamma/pc.hbar^2))*obj.xsForimpurity;
end