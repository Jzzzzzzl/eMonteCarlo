classdef PhononQuantityStatics < handle
    %% 声子统计类
    properties
        minimumTime
        minFrequency
        maxFrequency
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
        function obj = PhononQuantityStatics(pc, cc)
            %>构造函数
            obj.minFrequency = 0;
            obj.maxFrequency = pc.maxFrequency;
            obj.initializeVariables(cc);
        end
        
        function subPhononQuantityStatics(obj, sh, cc)
            %>声子分类统计
            sh.pHistory = reshape(sh.pHistory', [], 1);
            obj.frequencys = [sh.pHistory(:).frequency];
            obj.aborems = [sh.pHistory(:).aborem];
            obj.polars = [sh.pHistory(:).polar];
            obj.times = [sh.pHistory(:).time];
            
            obj.statisticPhonon(cc);
        end
        
    end
end