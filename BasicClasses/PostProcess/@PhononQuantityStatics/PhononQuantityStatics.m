classdef PhononQuantityStatics < handle
    %% 声子统计类
    properties
        allSumF
        allSumN
        minimumTime
        nDot
        Q
        n
        TF
        Teff
        pTeff
        polar
    end
    
    methods
        function obj = PhononQuantityStatics(cc)
            %>构造函数
            obj.initializeVariables(cc);
        end
        
        
    end
end