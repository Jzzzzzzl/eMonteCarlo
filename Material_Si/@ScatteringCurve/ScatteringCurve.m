classdef ScatteringCurve < handle
    %% 色散曲线类
    properties
        band
        bandLA
        bandTA
        bandLO
        bandTO
        gvLA
        gvTA
        gvLO
        gvTO
        dosLA
        dosTA
        dosLO
        dosTO
        taoLA
        taoTA
        taoLO
        taoTO
    end
    
    properties
        %各极化支频率定义域
        wMinLA
        wMaxLA
        wMinTA
        wMaxTA
        wMinLO
        wMaxLO
        wMinTO
        wMaxTO
        %谷间散射对应频率
        wgLA
        wgTA
        wgLO
        wgTO
        wfLA
        wfTA
        wfLO
        wfTO
    end
    
    methods
        function obj = ScatteringCurve(cc, pc)
            %>构造函数
            obj.initializeVariables(cc);
            obj.fitBandCoefficient(pc);
            obj.frequencyToInter(pc);
            obj.computeGroupVelocityDOSTao(cc, pc)
        end
        
        function frequencyToInter(obj, pc)
            %>谷间散射对应频率
            obj.wgLA = polyval(obj.bandLA, pc.qg);
            obj.wgTA = polyval(obj.bandTA, pc.qg);
            obj.wgLO = polyval(obj.bandLO, pc.qg);
            obj.wgTO = polyval(obj.bandTO, pc.qg);
            obj.wfLA = polyval(obj.bandLA, pc.qf);
            obj.wfTA = polyval(obj.bandTA, pc.qf);
            obj.wfLO = polyval(obj.bandLO, pc.qf);
            obj.wfTO = polyval(obj.bandTO, pc.qf);
        end
        
        function frequency = phononFrequency(obj, ps)
            %>计算PhononStatus对象频率
            switch ps.polar
                case "LA"
                    frequency = polyval(obj.bandLA, ps.wavenum);
                case "TA"
                    frequency = polyval(obj.bandTA, ps.wavenum);
                case "LO"
                    frequency = polyval(obj.bandLO, ps.wavenum);
                case "TO"
                    frequency = polyval(obj.bandTO, ps.wavenum);
                otherwise
                    error("声子极化支类型有误！")
            end
        end
    end
    
    methods
        initializeVariables(obj, cc)
        fitBandCoefficient(obj, pc)
        computeGroupVelocityDOSTao(obj, cc, pc)
    end
    
end
