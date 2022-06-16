classdef ScatteringCurveGaN < ScatteringCurve
    %% 色散曲线
    properties
        %谷间散射对应频率
        wPolarLO
        wU2ULA
        wU2ULO
        wU2GLA
        wU2GLO
        wG2GLA
        wG2GLO
    end
    
    methods
        function obj = ScatteringCurveGaN(cc, pc)
            %>构造函数
            obj.initializeVariables(cc);
            obj.fitBandCoefficient(pc);
            obj.frequencyToInter(pc);
            obj.computeGroupVelocityDOSTao(cc, pc)
        end
        
        function frequencyToInter(obj, pc)
            %>谷间散射对应频率
            obj.wPolarLO = polyval(obj.band.LO, 0.5 * pc.dBD);
            obj.wU2ULO = polyval(obj.band.LO, 0.1 * pc.dBD);
            obj.wU2GLO = polyval(obj.band.LO, 0.1 * pc.dBD);
            obj.wG2GLO = polyval(obj.band.LO, 0.1 * pc.dBD);
        end
        
    end
    
    methods
        initializeVariables(obj, cc)
        fitBandCoefficient(obj, pc)
        computeGroupVelocityDOSTao(obj, cc, pc)
    end
    
end
