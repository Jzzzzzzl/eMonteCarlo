classdef ScatterringProcessForValley < ScatterringRateTableForValley
    %% 本文件提供能谷散射过程父类
    % ======================================================================
    %>     属性说明：
    % ======================================================================
    %>     函数说明：
    %> （1）
    %> （2）
    %> （3）
    %>         
    % ======================================================================
    properties
        
    end
    
    methods
        [k] = chooseStandardVectorForElasticScattering(obj, es, pc, type)
        [k] = chooseStandardVectorForInelasticScattering(obj, es, pc, type, frequency, flag)
    end
end