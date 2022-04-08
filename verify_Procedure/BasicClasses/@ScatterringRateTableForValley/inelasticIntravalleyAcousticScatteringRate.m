function inelasticIntravalleyAcousticScatteringRate(obj, es, pc, cc)
    %>生成谷内声学散射句柄函数
    %>     参数说明：
    %>     D：形变势常量
    %>     u：横波/纵波波速
    % ======================================================================
    epsilonStar = obj.md*pc.u^2/2;
    Cstar = 4*epsilonStar^(1/2) ...
              / (pc.kb*cc.envTemp*(1-4*obj.alpha*epsilonStar/pc.e));
    condition = epsilonStar / (1-4*obj.alpha*epsilonStar/pc.e);
    if es.gamma <= condition
        x1a = Cstar*(sqrt(epsilonStar)*(1+2*obj.alpha*es.epsilon/pc.e) - real(sqrt(es.gamma)));
        x2a = Cstar*(sqrt(epsilonStar)*(1+2*obj.alpha*es.epsilon/pc.e) + real(sqrt(es.gamma)));
        x1e = 0;
        x2e = 0;
        obj.qAB = randNumber(x1a, x2a)*pc.kb*cc.envTemp / (pc.hbar*pc.u);
        obj.qEM = randNumber(x1e, x2e)*pc.kb*cc.envTemp / (pc.hbar*pc.u);
    else
        x1a = 0;
        x2a = Cstar*(real(sqrt(es.gamma)) + sqrt(epsilonStar)*(1+2*obj.alpha*es.epsilon/pc.e));
        x1e = 0;
        x2e = Cstar*(real(sqrt(es.gamma)) - sqrt(epsilonStar)*(1+2*obj.alpha*es.epsilon/pc.e));
        obj.qAB = randNumber(x1a, x2a)*pc.kb*cc.envTemp / (pc.hbar*pc.u);
        obj.qEM = randNumber(x1e, x2e)*pc.kb*cc.envTemp / (pc.hbar*pc.u);
    end
    obj.inelasticIntraAcousticAB = @(D) obj.md^(1/2)*(pc.kb*cc.envTemp)^3*D^2 ...
                                             / (2^(5/2)*pi*pc.hbar^4*pc.u^4*pc.rho)*real(es.gamma^(-1/2)) ...
                                             * ((1+2*obj.alpha*es.epsilon/pc.e) * (F1(x2a) - F1(x1a)) ...
                                             + 2*obj.alpha*pc.kb*cc.envTemp/pc.e * (F2(x2a) - F2(x1a)));
    obj.inelasticIntraAcousticEM = @(D) obj.md^(1/2)*(pc.kb*cc.envTemp)^3*D^2 ...
                                             / (2^(5/2)*pi*pc.hbar^4*pc.u^4*pc.rho)*real(es.gamma^(-1/2)) ...
                                             * ((1+2*obj.alpha*es.epsilon/pc.e) * (G1(x2e) - G1(x1e)) ...
                                             - 2*obj.alpha*pc.kb*cc.envTemp/pc.e * (G2(x2e) - G2(x1e)));
                                         
    function [value] = F1(x)
        %>电子谷内散射积分函数F1
        xabar = 3.5;
        if x <= xabar
            value = x^2/2 - x^3/6 + x^4/48 - x^6/4320;
        else
            value = xabar^2/2 - xabar^3/6 + xabar^4/48 - xabar^6/4320 ...
                    + exp(-xabar)*(xabar^2 + 2*xabar + 2) ...
                    - exp(-x)*(x^2 + 2*x + 2);
        end
    end
    
    function [value] = F2(x)
        %>电子谷内散射积分函数F2
        xabar = 3.5;
        if x <= xabar
            value = x^3/3 - x^4/8 + x^5/60 - x^7/5040;
        else
            value = xabar^3/3 - xabar^4/8 + xabar^5/60 - xabar^7/5040 ...
                    + exp(-xabar)*(xabar^3 + 3*xabar^2 + 6*xabar + 6) ...
                    - exp(-x)*(x^3 + 3*x^2 + 6*x + 6);
        end
    end

    function [value] = G1(x)
        %>电子谷内散射积分函数G1
        xebar = 4;
        if x <= xebar
            value = x^2/2 + x^3/6 + x^6/4320;
        else
            value = xebar^2/2 + xebar^3/6 + xebar^4/48 - xebar^6/4320 ...
                    + exp(-xebar)*(xebar^2 + 2*xebar + 2) - xebar^3/3 ...
                    - exp(-x)*(x^2 + 2*x + 2) + x^3/3;
        end
    end
    
    function [value] = G2(x)
        %>电子谷内散射积分函数G2
        xebar = 4;
        if x <= xebar
            value = x^3/3 + x^4/8 + x^5/60 - x^7/5040;
        else
            value = xebar^3/3 + xebar^4/8 + xebar^5/60 - xebar^7/5040 ...
                    + exp(-xebar)*(xebar^3 + 3*xebar^2 + 6*xebar + 6) - xebar^4/4 ...
                    - exp(-x)*(x^3 + 3*x^2 + 6*x + 6) + x^4/4;
        end
    end
end