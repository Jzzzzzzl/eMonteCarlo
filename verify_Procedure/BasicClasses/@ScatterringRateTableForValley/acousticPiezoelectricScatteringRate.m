function acousticPiezoelectricScatteringRate(obj, dv, es, pc, cc)
    %>生成声学压电散射句柄函数
    %>     参数说明：
    %>     n：自由载流子浓度
    % ======================================================================
    n = cc.dopDensity;
    beta = real(sqrt(4*pi^2*pc.e^2*n/(pc.epsilonL*pc.epsilon0*pc.kb*cc.envTemp)));
    obj.acousticPiezoelectric = sqrt(dv.bs.md)*pc.e^2*pc.p^2*pc.kb*cc.envTemp ...
                                        / (sqrt(8)*(pc.epsilonL*pc.epsilon0)^2*pc.hbar^2*pc.rho*pc.u^2) ...
                                        * real(dv.bs.epsilon^(-1/2)) ...
                                        * (log(1+8*pc.m*dv.bs.epsilon/(pc.hbar^2*beta^2)) ...
                                         - 1/(1+(pc.hbar^2*beta^2/(8*pc.m*dv.bs.epsilon))));
    if abs(es.wavenum / pc.dBD) > 0.1
        obj.thetaAP = acos(1-(beta^2*(exp((rand*(log(1+4*es.wavenum^2/beta^2)-1))+1)-1) / (2*es.wavenum^2)));
    else
        syms costheta
        fun = log(1+2*es.wavenum^2/beta^2*(1-costheta)) - (1-costheta)/(1-costheta+beta^2/(2*es.wavenum^2)) ...
                - rand*(log(1+4*es.wavenum^2/beta^2) - 1/(1+beta^2/(4*es.wavenum^2)));
        obj.thetaAP = real(acos(double(vpasolve(fun))));
    end
    if abs(obj.thetaAP) > pi
        error("thetaAP大于pi！")
    end
end