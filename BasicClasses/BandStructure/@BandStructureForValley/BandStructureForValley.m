classdef BandStructureForValley < handle
    %% 能谷能带结构父类
    properties
        %>带隙，以第一导带能谷极小值为基准
        Eg
        %>非抛物性参数
        alpha
        %>Herring-Vogt逆矩阵
        invTz
        %>横向有效质量
        mt
        %>纵向有效质量
        ml
        %>态密度有效质量
        md
        %>Herring-Vogt矩阵
        Tz
        %>能谷中心相对位置(0,1)
        centerRatio
    end
    
    methods
        [k] = generateStandardElectricWaveVector(obj, es, pc)
        [k] = chooseStandardVectorForScattering(obj, es, pc, frequency, flag)
    end
end
