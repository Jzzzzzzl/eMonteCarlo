classdef BandStructureForValley < handle
    %% 本文件提供能谷能带结构相关计算的父类
    properties
        Eg
        alpha
        invTz
    end
    properties
        mt
        ml
        md
        Tz
        centerRatio
    end
    
    methods
        [k] = generateStandardElectricWaveVector(obj, es, pc, theta)
    end
end
