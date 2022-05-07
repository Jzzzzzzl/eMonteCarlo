classdef ElectricQuantityStatics < handle
    %% 电子性质统计类
    properties(Constant)
        e = 1.602176634e-19;
    end
    
    properties
        aveTotalTime
        minimumTime
        mobilityTime
        mobilityField
        aveDriftVelocity
        aveEnergy
        driftVfield
        enumbers
        qnumbers
        diffusionCoe
        diffusionField
        occupyRate
        occupyField
    end
    
    properties
        positions
        vectors
        energys
        times
        perdrifts
        valleys
        scatypes
    end
    
    methods
        function obj = ElectricQuantityStatics(sh, cc)
            %>构造函数
            obj.extractElectricHistoryInformation(sh, cc)
            obj.averageTotalFlyTime(cc);
        end
        
        function averageTotalFlyTime(obj, cc)
            %>计算平均总飞行时间
            endTimes = obj.times(:, end);
            obj.aveTotalTime = sum(endTimes) / cc.superElecs;
            obj.minimumTime = min(endTimes);
            disp(['平均总模拟时间： ', num2str(obj.aveTotalTime * 1e12), '  ps']);
            disp(['最短运动时间为： ', num2str(obj.minimumTime * 1e12), '  ps']);
        end
        
    end
    
    methods
        averageEnergyWithTime(obj, cc, N)
        electronDiffusionCoefficient(obj, cc)
        energyHistoryDistribution(obj, cc, N)
        extractElectricHistoryInformation(obj, sh, cc)
        plotProperties(obj)
        pulsesFieldDirftVelocityWithTime(obj, cc, N)
    end
end