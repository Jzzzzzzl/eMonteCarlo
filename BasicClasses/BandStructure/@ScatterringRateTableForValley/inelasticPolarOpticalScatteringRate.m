function inelasticPolarOpticalScatteringRate(obj, es, pc)
    %>生成极化光学散射率句柄函数
    %>     参数说明：
    %>     w：某光学支的声子平均频率
    T = es.devTem;
    global e alpha epsilon0
    e = pc.e;
    alpha = obj.alpha;
    epsilon0 = es.epsilon;
    
    gamma = @(epsilon) epsilon*(1 + alpha*epsilon/e);
    
    epsilonAB = @(w) epsilon0 + pc.hbar * w;
    obj.inelasticPolarOpticalAB = @(w) e^2*sqrt(obj.md) * w/(4*pi*sqrt(2)*pc.hbar*pc.epsilon0) ...
                                                  * (1/pc.epsilonH - 1/pc.epsilonL) ...
                                                  * (1+2*alpha*epsilonAB(w)/e)/real(sqrt(gamma(epsilon0))) ...
                                                  * F0(epsilonAB(w)) ...
                                                  * (1/(exp(pc.hbar * w / (pc.kb*T)) - 1)) ...
                                                  * obj.xsForPolarOptical;
    obj.thetaPOab = @(w) computeTheta(epsilonAB(w));
    epsilonEM = @(w) epsilon0 - pc.hbar * w;
    obj.inelasticPolarOpticalEM = @(w) e^2*sqrt(obj.md) * w/(4*pi*sqrt(2)*pc.hbar*pc.epsilon0) ...
                                                  * (1/pc.epsilonH - 1/pc.epsilonL) ...
                                                  * (1+2*alpha*epsilonEM(w)/e)/real(sqrt(gamma(epsilon0))) ...
                                                  * F0(epsilonEM(w)) ...
                                                  * (1 + 1/(exp(pc.hbar * w / (pc.kb*T)) - 1)) ...
                                                  * obj.xsForPolarOptical;
    obj.thetaPOem = @(w) computeTheta(epsilonEM(w));
    function [value] = A(epsilon1)
        %>
        value = (2*(1+2*alpha*epsilon0/e)*(1+alpha*epsilon1/e) ...
                  + alpha*(gamma(epsilon0)+gamma(epsilon1))/e)^2;
    end
    function [value] = B(epsilon1)
        %>
        value = -2*alpha*real(sqrt(gamma(epsilon0)))*real(sqrt(gamma(epsilon1)))/e ...
                  * (4*(1+alpha*epsilon0/e)*(1+alpha*epsilon1/e) ...
                  + alpha*(gamma(epsilon0)+gamma(epsilon1))/e);
    end
    function [value] = C(epsilon1)
        %>
        value = 4*(1+alpha*epsilon0/e)*(1+alpha*epsilon1/e) ...
                  * (1+2*alpha*epsilon0/e)*(1+2*alpha*epsilon1/e);
    end
    function [value] = F0(epsilon1)
        %>
        value = C(epsilon1)^(-1)*(A(epsilon1) ...
                 * log(abs((real(sqrt(gamma(epsilon0))) + real(sqrt(gamma(epsilon1)))) ...
                 / (real(sqrt(gamma(epsilon0))) - real(sqrt(gamma(epsilon1)))))) + B(epsilon1));
    end
    function [value] = computeTheta(epsilon1)
        %>
        f = 2*real(sqrt(epsilon0*epsilon1))/(real(sqrt(epsilon0)) - real(sqrt(epsilon1)))^2;
        value = acos(((1+f) - (1+2*f)^rand)/f);
    end
end