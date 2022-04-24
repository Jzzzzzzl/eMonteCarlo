classdef ScatteringCurve < handle
    %% 色散曲线
    properties
        band
        bandLA
        bandLO
        gvLA
        gvLO
        dosLA
        dosLO
        taoLA
        taoLO
    end
    
    properties
        %各极化支频率定义域
        wMinLA
        wMaxLA
        wMinLO
        wMaxLO
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
        function obj = ScatteringCurve(cc, pc)
            %>构造函数
            obj.initializeVariables(cc);
            obj.fitBandCoefficient(pc);
            obj.frequencyToInter(pc);
            obj.computeGroupVelocityDOSTao(cc, pc)
        end
        
        function frequencyToInter(obj, pc)
            %>谷间散射对应频率
            obj.wPolarLO = polyval(obj.bandLO, 0.5 * pc.dBD);
            obj.wU2ULO = polyval(obj.bandLO, 0.1 * pc.dBD);
            obj.wU2GLO = polyval(obj.bandLO, 0.1 * pc.dBD);
            obj.wG2GLO = polyval(obj.bandLO, 0.1 * pc.dBD);
        end
        
        function frequency = phononFrequency(obj, ps)
            %>计算PhononStatus对象频率
            switch ps.polar
                case "LA"
                    frequency = polyval(obj.bandLA, ps.wavenum);
                case "LO"
                    frequency = polyval(obj.bandLO, ps.wavenum);
                otherwise
                    error("声子极化支类型有误！")
            end
        end
        
    end
    
    methods
        initializeVariables(obj, cc)
        fitBandCoefficient(obj, pc)
        computeGroupVelocityDOSTao(obj, cc, pc)
    end
    
end
