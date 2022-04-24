classdef EPWaveVectorModify < handle
    %% 
    
    properties
        
    end
    
    methods
        [es] = modifyElectricWaveVector(obj, es, pc)
    end
    
    methods(Static)
        [ps] = phononWhetherBeyondBZ(ps, pc)
        [bool] = electricWhetherBeyondBZ(k, pc)
        [value] = whichValley(es)
    end
end