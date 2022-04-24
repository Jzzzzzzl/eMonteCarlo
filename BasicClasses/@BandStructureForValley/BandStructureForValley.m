classdef BandStructureForValley < handle
    %% 本文件提供能谷能带结构相关计算的父类
    properties
        Eg
        mt
        ml
        md
        alpha
        Tz
        invTz
        centerRatio
    end
    
    methods
        [k] = generateStandardElectricWaveVector(obj, es, pc, theta)
    end
end
