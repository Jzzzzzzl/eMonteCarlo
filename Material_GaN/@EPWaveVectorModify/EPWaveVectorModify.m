classdef EPWaveVectorModify < handle
    %% 电声子波矢修正类
    
    methods
        [es] = modifyElectricWaveVector(obj, es, pc)
    end
    
    methods(Static)
        [ps] = phononWhetherBeyondBZ(ps, pc)
        [bool] = electricWhetherBeyondBZ(k, pc)
        [value] = whichValley(es)
    end
end