classdef ScatterringCurve < handle
    %% 色散曲线
    properties
        frequency
        omegaLA
        omegaLO
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
            obj.omegaLA = @(q) 0.000e13 + 8.861e3*q - 1.931e-7*q.^2;
            obj.omegaLO = @(q) 9.473e13 + 5.876e2*q - 1.950e-7*q.^2;
            %计算定义域及谷间声子频率
            obj.frequencyDomain(pc);
            obj.frequencyToInter(pc);
        end
        
        function frequencyDomain(obj, pc)
            %>各极化支频率定义域
%             obj.wMinLA = double(obj.omegaLA(0));
%             obj.wMaxLA = double(obj.omegaLA(pc.dGX));
%             obj.wMinLO = double(obj.omegaLO(pc.dGX));
%             obj.wMaxLO = double(obj.omegaLO(0));
        end
        
        function frequencyToInter(obj, pc)
            %>谷间散射对应频率
            obj.wPolarLO = 2.2e13;
            obj.wU2ULA = 0.8e13;
            obj.wU2ULO = 2.3e13;
            obj.wU2GLA = 1.2e13;
            obj.wU2GLO = 2.2e13;
            obj.wG2GLA = 0.5e13;
            obj.wG2GLO = 2.2e13;
%             obj.wU2ULA = double(obj.omegaLA(pc.qU2U));
%             obj.wU2ULO = double(obj.omegaLO(pc.qU2U));
%             obj.wU2GLA = double(obj.omegaLA(pc.qU2G));
%             obj.wU2GLO = double(obj.omegaLO(pc.qU2G));
        end
        
        function frequency = phononFrequency(obj, ps)
            %>计算PhononStatus对象频率
            switch ps.polar
                case "LA"
                    frequency = double(obj.omegaLA(ps.wavenum));
                case "LO"
                    frequency = double(obj.omegaLO(ps.wavenum));
                otherwise
                    error("声子极化支类型有误！")
            end
            
        end
        
    end
end
