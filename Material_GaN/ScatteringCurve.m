classdef ScatteringCurve < handle
    %% 色散曲线
    properties
        frequency
        bandLA
        bandLO
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
        function obj = ScatterringCurve(pc)
            %>构造函数
            obj.bandLA = [-2.66610530103502e-18,4.03688695146239e-09, ...
                                1188.20113406174,-12317168559.2966];
            obj.bandLO = [-3.60800908165332e-37,1.34049749810303e-26, ...
                               -1.73789147769978e-16,8.42729511038591e-07, ...
                               -498.359180281836,18002632666019.3];
            %计算定义域及谷间声子频率
            obj.frequencyDomain(pc);
            obj.frequencyToInter(pc);
        end
        
        function frequencyDomain(obj, ~)
            %>各极化支频率定义域
            obj.wMinLA = 0;
            obj.wMaxLA = 1.0290e+13;
            obj.wMinLO = 1.7974e+13;
            obj.wMaxLO = 2.2343e+13;
        end
        
        function frequencyToInter(obj, pc)
            %>谷间散射对应频率
            obj.wPolarLO = 1.3825e+14;
            obj.wU2ULO = 1.0002e+14;
            obj.wU2GLO = 1.0002e+14;
            obj.wG2GLO = 1.0002e+14;
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
end
