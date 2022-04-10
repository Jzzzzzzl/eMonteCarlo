classdef EPWaveVectorModify < handle
    %% 
    
    properties
        
    end
    
    methods
        [es] = modifyElectricWaveVector(obj, es, pc)
    end
    
    methods(Static)
        [value] = whichValley(es)
        [ps] = phononWhetherBeyondBZ(ps, pc)
        [bool] = electricWhetherBeyondBZ(k, pc)
    end
end