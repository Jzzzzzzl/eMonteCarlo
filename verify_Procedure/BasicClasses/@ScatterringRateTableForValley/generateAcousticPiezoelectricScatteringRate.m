function generateAcousticPiezoelectricScatteringRate(obj, dv, pc, cc)
    %>生成声学压电散射句柄函数
    %>     参数说明：
    %>     n：自由载流子浓度
    % ======================================================================
    n = cc.dopDensity;
    beta = sqrt(4*pi^2*pc.e^2*n/(pc.epsilonL*pc.epsilon0*pc.kb*cc.envTemp));
    obj.acousticPiezoelectricScatRate = sqrt(dv.bs.md)*pc.e^2*pc.p^2*pc.kb*cc.envTemp ...
                                                    / (sqrt(8)*(pc.epsilonL*pc.epsilon0)^2*pc.hbar^2*pc.rho*pc.u^2) ...
                                                    *real(dv.bs.epsilon^(-1/2)) ...
                                                    *(log(1+8*dv.bs.md*dv.bs.epsilon/(pc.hbar^2*beta^2)) ...
                                                    - 1/(1+(pc.hbar^2*beta^2/(8*dv.bs.md*dv.bs.epsilon))));
    
end