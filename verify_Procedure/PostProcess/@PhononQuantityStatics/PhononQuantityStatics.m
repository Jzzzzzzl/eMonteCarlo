classdef PhononQuantityStatics < handle
    
    properties
        NW
        minFrequency
        maxFrequency
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
        frequencys
        aborems
        polars
    end
    
    methods
        
        function obj = PhononQuantityStatics(pc, NW)
            %构造函数
            obj.NW = NW;
            obj.minFrequency = 0;
            obj.maxFrequency = pc.maxFrequency;
            obj.initializePhononIndexStorage;
        end
        
        function subPhononQuantityStatics(obj, sh, mm)
            %全部计算一遍
            sh.pHistory = reshape(sh.pHistory', [], 1);
            obj.frequencys = [sh.pHistory(:).frequency];
            obj.aborems = [sh.pHistory(:).aborem];
            obj.polars = [sh.pHistory(:).polar];
            
            obj.statisticPhonon(mm);
        end
        
    end
end