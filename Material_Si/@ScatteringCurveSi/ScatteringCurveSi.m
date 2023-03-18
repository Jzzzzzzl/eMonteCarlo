classdef ScatteringCurveSi < ScatteringCurve
    %% 色散曲线类
    properties
        %>谷内声学散射对应频率
        wa
        %>谷间散射对应频率
        wg
        wf
    end
    
    methods
        function obj = ScatteringCurveSi(cc, pc)
            %>构造函数
            obj.initializeVariables(cc);
            obj.fitBandCoefficient(pc);
            obj.frequencyToInterScat(pc);
            obj.computeGroupVelocityDOSTao(cc, pc)
        end
        
        function frequencyToInterScat(obj, pc)
            %>谷内声学散射对应频率
            obj.wa.LA = polyval(obj.band.LA, pc.qa);
            obj.wa.TA = polyval(obj.band.TA, pc.qa);
            %>谷间散射对应频率
            obj.wg.LA = polyval(obj.band.LA, pc.qg);
            obj.wg.TA = polyval(obj.band.TA, pc.qg);
            obj.wg.LO = polyval(obj.band.LO, pc.qg);
            obj.wg.TO = polyval(obj.band.TO, pc.qg);
            obj.wf.LA = polyval(obj.band.LA, pc.qf);
            obj.wf.TA = polyval(obj.band.TA, pc.qf);
            obj.wf.LO = polyval(obj.band.LO, pc.qf);
            obj.wf.TO = polyval(obj.band.TO, pc.qf);
        end
    end
    
    methods
        initializeVariables(obj, cc)
        fitBandCoefficient(obj, pc)
        getBandDataFromOther(obj, cc)
        plotScatteringCurve(obj, pc)
        computeGroupVelocityDOSTao(obj, cc, pc)
    end
    
end
