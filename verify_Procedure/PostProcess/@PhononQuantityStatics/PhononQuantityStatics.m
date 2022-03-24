classdef PhononQuantityStatics < handle
    %% 声子统计类
    properties
        NW
        minFrequency
        maxFrequency
        frequencys
        aborems
        polars
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
    end
    
    methods
        function obj = PhononQuantityStatics(pc, NW)
            %>构造函数
            obj.NW = NW;
            obj.minFrequency = 0;
            obj.maxFrequency = pc.maxFrequency;
            obj.initializePhononIndexStorage;
        end
        
        function subPhononQuantityStatics(obj, sh, mm)
            %>声子分类统计
            sh.pHistory = reshape(sh.pHistory', [], 1);
            obj.frequencys = [sh.pHistory(:).frequency];
            obj.aborems = [sh.pHistory(:).aborem];
            obj.polars = [sh.pHistory(:).polar];
            
            obj.statisticPhonon(mm);
        end
        
    end
end