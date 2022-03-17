classdef ScatterringRateTableForValley < handle
    %% 本文件提供能谷散射表父类
    % ======================================================================
    %>     属性说明：
    %>
    % ======================================================================
    %>     函数说明：
    %> （1）
    %>         
    %> （2）
    %>         
    %>
    % ======================================================================
    properties
        impurityScatRate
        intraScatRate
        interScatRate
        deltaBandEnergy
        maxScatRate
        md
        scatTable
        scatTableAll
        scatType
        flyTime
    end
    
    methods
        function ScatterringRateFomular(obj, pc, cc)
            %电离杂质散射(弹性近似)
            b = @(E, n) pc.e^2*pc.hbar^2*n / (8*pc.epsilon0*pc.epsilon*pc.kb*cc.envTemp*obj.md*E);
            obj.impurityScatRate = @(E, n) sqrt(2)*pi*n*pc.e^4 / ((4*pi*pc.epsilon0*pc.epsilon)^2*obj.md^(1/2))...
                                                     *E^(-3/2)/(4*b(E, n) * (1 + b(E, n)))*cc.xsForimpurity;
            %声学波形变势散射(弹性近似)
            obj.intraScatRate = @(E, D, u) sqrt(2)*obj.md^(3/2)*pc.kb*cc.envTemp*D^2 /...
                                                     (pi*pc.hbar^4*u^2*pc.rho)*E^(1/2);
            %谷间散射(非弹性近似)
            obj.interScatRate = @(E, DK, Zf, w, flag) DK^2*obj.md^(3/2)*Zf / (sqrt(2)*pi*pc.rho*pc.hbar^3*w)...
                                                                  *(1/2 + flag/2 + 1/(exp(pc.hbar*w/(pc.kb*cc.envTemp))-1))...
                                                                  *real(sqrt(E - flag*pc.hbar*w - obj.deltaBandEnergy));
        end
        
        function computeScatType(obj)
            %计算散射类型
            r = rand * obj.scatTableAll(end);
            obj.scatType = find(obj.scatTableAll > r, 1);
        end
        
        function computeFlyTime(obj)
            %计算飞行时间
            obj.flyTime = -log(randNumber(0.01,1.0)) / obj.maxScatRate;
        end
        
    end
end