function generatePolarOpticalScatteringRate(obj, dv, pc, cc)
    %>生成极化光学散射率句柄函数
    %>     参数说明：
    %>     w：某光学支的声子平均频率
    %>
    % ======================================================================
    global e alpha epsilon0
    e = pc.e;
    alpha = dv.bs.alpha;
    epsilon0 = dv.bs.epsilon;
    
    gamma = @(epsilon) epsilon*(1 + alpha*epsilon/e);
    
    epsilonAB = @(w) epsilon0 + pc.hbar * w;
    obj.polarOpticalScatRateAB = @(w) e^2*sqrt(dv.bs.md)*w/(sqrt(2)*pc.hbar) ...
                                                  * (1/pc.epsilonH - 1/pc.epsilonL)/pc.epsilon0 ...
                                                  * (1+2*alpha*epsilonAB(w)/e)/real(sqrt(gamma(epsilon0))) ...
                                                  * F0(epsilonAB(w))*(1/(exp(pc.hbar*w / (pc.kb*cc.envTemp)) - 1)) ...
                                                  * obj.xsForPolarOptical;
    epsilonEM = @(w) epsilon0 - pc.hbar * w;
    obj.polarOpticalScatRateEM = @(w) e^2*sqrt(dv.bs.md)*w/(sqrt(2)*pc.hbar) ...
                                                  * (1/pc.epsilonH - 1/pc.epsilonL)/pc.epsilon0 ...
                                                  * (1+2*alpha*epsilonEM(w)/e)/real(sqrt(gamma(epsilon0))) ...
                                                  * F0(epsilonEM(w))*(1 + 1/(exp(pc.hbar*w / (pc.kb*cc.envTemp)) - 1)) ...
                                                  * obj.xsForPolarOptical;
    
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
end