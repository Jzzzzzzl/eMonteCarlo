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
        %>飞行时间最小值
        minTime
        %>飞行时间最大值
        maxTime
        %>最大统计能量
        maxEnergy
        %>平均能量随时间变化
        aveETime
        %>平均能量随位置变化
        aveEPos
        %>漂移速度随时间变化
        driftVTime
        %>漂移速度随电场变化
        driftVField
        %>能量分布统计
        eNums
        %>能谷占据数随时间变化
        occTime
        %>能谷占据数随电场变化
        occField
        %>能谷散射类型统计
        scatNums
        %>散射类型柱状统计
        snumbers
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
        function obj = ElectricQuantityStatics
            %>构造函数
            
        end
        
    end
    
    methods
        
    end
end