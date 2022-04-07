classdef ElectricQuantityStatics < handle
    %% 后处理类
    properties(Constant)
        e = 1.602176634e-19;
    end
    
    properties
        aveTotalTime
        minimumTime
        mobility
        aveDriftVelocity
        diffusionCoe
        occupyRate
    end
    
    methods
        function obj = ElectricQuantityStatics(sh, pc, cc)
            %>构造函数
            obj.averageTotalFlyTime(sh, cc);
            obj.electronDiffusionCoefficient(sh, cc)
            obj.electronMobility(pc, cc)
        end
        
        function averageTotalFlyTime(obj, sh, cc)
            %>计算平均总飞行时间
            times = [sh.eHistory(:, end).time];
            obj.aveTotalTime = sum(times) / cc.superElecs;
            obj.minimumTime = min(min(times));
            disp(['平均总模拟时间： ', num2str(obj.aveTotalTime * 1e12), '  ps']);
            disp(['最短运动时间为： ', num2str(obj.minimumTime * 1e12), '  ps']);
        end
        
        function electronMobility(obj, pc, cc)
            %>计算迁移率
            obj.mobility = obj.e*obj.diffusionCoe ...
                            / (pc.kb*cc.envTemp*(1 + 0.35355*cc.dopDensity/(2.18e21*cc.envTemp^(3/2))));
            disp(['电子迁移率为： ', num2str(obj.mobility * 1e4), '  cm^2/(V*s)']);
        end
        
        function electronDiffusionCoefficient(obj, sh, cc)
            %>计算扩散系数
            diffusion = zeros(cc.superElecs, 1);
            for i = 1 : cc.superElecs
                sum2ave = 0;
                for j = 2 : cc.noFly
                    x = sh.eHistory(i, j).position - sh.eHistory(i, j-1).position;
                    sum2ave = sum2ave + x(1)^2;
                end
                ave2ave = sum2ave / (cc.noFly - 1);
                x = sh.eHistory(i, end).position - sh.eHistory(i, 1).position;
                t = sh.eHistory(i, end).time - sh.eHistory(i, 1).time;
                aveave2 = x(1)^2;
                diffusion(i) = (ave2ave - aveave2) / t;
            end
            obj.diffusionCoe = abs(sum(diffusion) / cc.superElecs);
            disp(['电子扩散系数为： ', num2str(obj.diffusionCoe * 1e4), '  cm^2/s']);
        end
    end
    
end