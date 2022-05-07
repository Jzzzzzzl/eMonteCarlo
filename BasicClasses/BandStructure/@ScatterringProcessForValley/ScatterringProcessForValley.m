classdef ScatterringProcessForValley < ScatterringRateTableForValley
    %% 本文件提供能谷散射过程父类    
    methods
        [k] = chooseStandardVectorForElasticScattering(obj, es, pc, type)
        [k] = chooseStandardVectorForInelasticScattering(obj, es, pc, type, frequency, flag)
    end
end