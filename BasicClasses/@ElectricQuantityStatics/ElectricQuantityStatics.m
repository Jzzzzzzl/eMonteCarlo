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
            n = max(max(cc.dopDensity.data));
            obj.mobility = obj.e*obj.diffusionCoe ...
                            / (pc.kb*cc.envTemp*(1 + 0.35355*n/(2.18e21*cc.envTemp^(3/2))));
            disp(['电子迁移率为： ', num2str(obj.mobility * 1e4), '  cm^2/(V*s)']);
        end
        
    end
    
    methods
        energyHistoryDistribution(obj, sh, cc, e, N)
        averageEnergyWithTime(obj, sh, cc, N)
        dirftVelocityWithTime(obj, sh, cc, N)
        electronDiffusionCoefficient(obj, sh, cc)
        electronTrace(obj, sh, cc, num, type)
    end
end