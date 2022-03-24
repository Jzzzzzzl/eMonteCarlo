classdef ScatterringCurve < handle
    %% 色散曲线
    properties
        frequency
        omegaLA
        omegaTA
        omegaLO
        omegaTO
    end
    
    properties
        %各极化支频率定义域
        wMinLA
        wMaxLA
        wMinTA
        wMaxTA
        wMinLO
        wMaxLO
        wMinTO
        wMaxTO
        %谷间散射对应频率
        wgLA
        wgTA
        wgLO
        wgTO
        wfLA
        wfTA
        wfLO
        wfTO
    end
    
    methods
        function obj = ScatterringCurve(pc)
            %>构造函数
            obj.omegaLA = @(q) 0.000e13 + 8.861e3*q - 1.931e-7*q.^2;
            obj.omegaTA = @(q) 0.000e13 + 5.993e3*q - 3.165e-7*q.^2;
            obj.omegaLO = @(q) 9.473e13 + 5.876e2*q - 1.950e-7*q.^2;
            obj.omegaTO = @(q) 9.824e13 - 2.547e3*q + 1.140e-7*q.^2;
            %计算定义域及谷间声子频率
            obj.frequencyDomain(pc);
            obj.frequencyToInter(pc);
        end
        
        function frequencyDomain(obj, pc)
            %>各极化支频率定义域
            obj.wMinLA = double(obj.omegaLA(0));
            obj.wMaxLA = double(obj.omegaLA(pc.dGX));
            obj.wMinTA = double(obj.omegaTA(0));
            obj.wMaxTA = double(obj.omegaTA(pc.dGX));
            obj.wMinLO = double(obj.omegaLO(pc.dGX));
            obj.wMaxLO = double(obj.omegaLO(0));
            obj.wMinTO = double(obj.omegaTO(pc.dGX));
            obj.wMaxTO = double(obj.omegaTO(0));
        end
        
        function frequencyToInter(obj, pc)
            %>谷间散射对应频率
            obj.wgLA = double(obj.omegaLA(pc.qg));
            obj.wgTA = double(obj.omegaTA(pc.qg));
            obj.wgLO = double(obj.omegaLO(pc.qg));
            obj.wgTO = double(obj.omegaTO(pc.qg));
            obj.wfLA = double(obj.omegaLA(pc.qf));
            obj.wfTA = double(obj.omegaTA(pc.qf));
            obj.wfLO = double(obj.omegaLO(pc.qf));
            obj.wfTO = double(obj.omegaTO(pc.qf));
        end
        
        function frequency = phononFrequency(obj, ps)
            %>计算PhononStatus对象频率
            switch ps.polar
                case "LA"
                    frequency = double(obj.omegaLA(ps.wavenum));
                case "TA"
                    frequency = double(obj.omegaTA(ps.wavenum));
                case "LO"
                    frequency = double(obj.omegaLO(ps.wavenum));
                case "TO"
                    frequency = double(obj.omegaTO(ps.wavenum));
                otherwise
                    error("声子极化支类型有误！")
            end
            
        end
        
    end
end
