classdef ScatteringCurve < handle
    %% 色散曲线类
    properties
        %>极化支结构体
        polar
        %>能带存储矩阵
        qband
        %>能带结构体
        band
        %>群速度结构体
        gv
        %>态密度结构体
        dos
        %>弛豫时间结构体
        tao
    end
    
    properties
        %各极化支频率定义域
        wMin
        wMax
        %谷间散射对应频率
        wg
        wf
    end
    
    methods
        function obj = ScatteringCurve(cc, pc)
            %>构造函数
            obj.initializeVariables(cc);
            obj.fitBandCoefficient(pc);
            obj.frequencyToInterScat(pc);
            obj.computeGroupVelocityDOSTao(cc, pc)
        end
        
        function frequencyToInterScat(obj, pc)
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
        
        function frequency = phononFrequency(obj, ps)
            %>计算PhononStatus对象频率
            switch ps.polar
                case "LA"
                    frequency = polyval(obj.band.LA, ps.wavenum);
                case "TA"
                    frequency = polyval(obj.band.TA, ps.wavenum);
                case "LO"
                    frequency = polyval(obj.band.LO, ps.wavenum);
                case "TO"
                    frequency = polyval(obj.band.TO, ps.wavenum);
                otherwise
                    error("声子极化支类型有误！")
            end
        end
    end
    
    methods
        initializeVariables(obj, cc)
        fitBandCoefficient(obj, pc)
        getBandDataFromOther(obj, cc)
        computeGroupVelocityDOSTao(obj, cc, pc)
    end
    
end
