classdef ElectricQuantityStatics < handle
    %% 电子性质统计类
    properties(Constant)
        e = 1.602176634e-19;
        m = 9.10956e-31;
        kb = 1.380649e-23;
        h = 6.6260755e-34;
        hbar = 1.05457266e-34;
        epsilon0 = 8.854187817e-12;
    end
    
    properties
        %>平均飞行时间
        aveTime
        %>最小飞行时间
        minTime
        %>迁移率随时间变化
        mobTime
        %>迁移率随电场变化
        mobField
        %>平均能量随时间变化
        aveETime
        %>漂移速度随时间变化
        driftVTime
        %>漂移速度随电场变化
        driftVField
        %>能量分布统计
        eNums
        %>波矢分布统计
        qNums
        %>扩散系数随时间变化
        dcoTime
        %>扩散系数随电场变化
        dcoField
        %>能谷占据数随时间变化
        occTime
        %>能谷占据数随电场变化
        occField
        %>漏断电流随时间变化
        curTime
    end
    
    properties
        %>电子历史信息
        positions
        vectors
        energys
        times
        perdrifts
        valleys
        scatypes
    end
    
    methods
        function obj = ElectricQuantityStatics(cc)
            %>构造函数
            fileID = fopen([cc.filePath 'ElectronLog']);
            obj.extractElectricHistoryInformation(fileID, cc);
            obj.averageTotalFlyTime(cc);
        end
        
        function averageTotalFlyTime(obj, cc)
            %>计算平均总飞行时间
            endTimes = obj.times(:, end);
            obj.aveTime = sum(endTimes) / cc.superElecs;
            obj.minTime = min(endTimes);
            disp(['平均总模拟时间： ', num2str(obj.aveTime * 1e12), '  ps']);
            disp(['最短运动时间为： ', num2str(obj.minTime * 1e12), '  ps']);
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