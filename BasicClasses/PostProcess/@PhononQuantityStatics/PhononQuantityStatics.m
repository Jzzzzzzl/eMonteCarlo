classdef PhononQuantityStatics < handle
    %% 声子统计类
    properties
        minimumTime
        xpositions
        ypositions
        vectors
        frequencys
        aborems
        polars
        times
        phLAab
        phLAem
        phTAab
        phTAem
        phLOab
        phLOem
        phTOab
        phTOem
        phALLab
        phALLem
        nDot
        Q
        n
        TF
        Teff
        pTeff
    end
    
    methods
        function obj = PhononQuantityStatics(cc)
            %>构造函数
            obj.initializeVariables(cc);
            
        end
        
        
    end
end