function acousticPiezoelectricScatteringRate(obj, es, pc, cc)
    %>生成声学压电散射句柄函数
    n = cc.computeDopingDensity(es);
    T = cc.computeDeviceTemperature(es);
    beta = real(sqrt(4*pi^2*pc.e^2*n/(pc.epsilonL*pc.epsilon0*pc.kb*T)));
    obj.acousticPiezoelectric = sqrt(obj.md)*pc.e^2*pc.p^2*pc.kb*T ...
                                        / (sqrt(8)*(pc.epsilonL*pc.epsilon0)^2*pc.hbar^2*pc.rho*pc.u^2) ...
                                        * real(es.epsilon^(-1/2)) ...
                                        * (log(1+8*pc.m*es.epsilon/(pc.hbar^2*beta^2)) ...
                                         - 1/(1+(pc.hbar^2*beta^2/(8*pc.m*es.epsilon))));
    x = beta/es.wavenum;
    if eq(x, 0) || ~isfinite(x)
        x = rand;
    end
    y = (1 - rand)*log(x^2) + rand*log(x^2 + 4) - 4*rand/(4 + x^2);
    f = @(m) (1 - m + x^2/2)*log(x^2 + 2*(1-m)) - (1-m)*(1+y) - x^2*y/2;
    opt = optimset('Display', 'off');
    obj.thetaAP = real(double(acos(fsolve(f, pi/2, opt))));
end