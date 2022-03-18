function intravalleyAcousticScatteringRate(obj, es, dv, pc, cc)
    %> 谷内声学散射
    epsilongStar = obj.md*pc.u^2/2;
    Cstar = 4*epsilongStar^(1/2) ...
              / (pc.kb*cc.envTemp*(1-4*dv.bs.alpha*epsilongStar));
    condition = epsilongStar / (1-4*dv.bs.alpha*epsilongStar);%该值量级1e-5 eV
    gamma = es.energy - dv.bs.Eg;
    if gamma <= condition
        x1a = Cstar*(sqrt(epsilongStar)*(1+2*dv.bs.alpha*dv.bs.epsilong) - sqrt(gamma));
        x2a = Cstar*(sqrt(epsilongStar)*(1+2*dv.bs.alpha*dv.bs.epsilong) + sqrt(gamma));
        x1e = 0;
        x2e = 0;
    else
        x1a = 0;
        x2a = Cstar*(sqrt(gamma) + sqrt(epsilongStar)*(1+2*dv.bs.alpha*dv.bs.epsilong));
        x1e = 0;
        x2e = Cstar*(sqrt(gamma) - sqrt(epsilongStar)*(1+2*dv.bs.alpha*dv.bs.epsilong));
    end
    obj.intraAcousticScatRateAB = @(D, u) obj.md^(1/2)*(pc.kb*cc.envTemp)^3*D^2 ...
                                             / (2^(5/2)*pi*pc.hbar^4*pc.u^4*pc.rho)*gamma^(-1/2) ...
                                             * ((1+2*dv.bs.alpha*dv.bs.epsilong) * (obj.F1(x2a) - obj.F1(x1a)) ...
                                             + 2*dv.bs.alpha*pc.kb*cc.envTemp * (obj.F2(x2a) - obj.F2(x1a)));
    obj.intraAcousticScatRateEM = @(D, u) obj.md^(1/2)*(pc.kb*cc.envTemp)^3*D^2 ...
                                             / (2^(5/2)*pi*pc.hbar^4*pc.u^4*pc.rho)*gamma^(-1/2) ...
                                             * ((1+2*dv.bs.alpha*dv.bs.epsilong) * (obj.G1(x2e) - obj.G1(x1e)) ...
                                             - 2*dv.bs.alpha*pc.kb*cc.envTemp * (obj.G2(x2e) - obj.G2(x1e)));
end