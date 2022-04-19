classdef ScatteringCurve < handle
    %% 色散曲线
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
        
        function computeGroupVelocityDOSTao(obj, cc, pc)
            %>
            % 计算群速度表/态密度表
            for k = 1 : cc.NW
                if cc.frequency.point(k+1) >= obj.wMinLA && cc.frequency.point(k+1) <= obj.wMaxLA
                    obj.gvLA(k+1) = spline(obj.band(:, 2), obj.band(:, 8), cc.frequency.point(k+1));
                    obj.dosLA(k+1) = 3*cc.frequency.point(k+1)^2 / (2*pi^2*obj.gvLA(k+1)^3);
                end
                if cc.frequency.point(k+1) >= obj.wMinTA && cc.frequency.point(k+1) <= obj.wMaxTA
                    obj.gvTA(k+1) = spline(obj.band(:, 3), obj.band(:, 9), cc.frequency.point(k+1));
                    obj.dosTA(k+1) = 3*cc.frequency.point(k+1)^2 / (2*pi^2*obj.gvTA(k+1)^3);
                end
                if cc.frequency.point(k+1) >= obj.wMinLO && cc.frequency.point(k+1) <= obj.wMaxLO
                    obj.gvLO(k+1) = spline(obj.band(:, 5), obj.band(:, 10), cc.frequency.point(k+1));
                    obj.dosLO(k+1) = 3*cc.frequency.point(k+1)^2 / (2*pi^2*obj.gvLO(k+1)^3);
                end
                if cc.frequency.point(k+1) >= obj.wMinTO && cc.frequency.point(k+1) <= obj.wMaxTO
                    obj.gvTO(k+1) = spline(obj.band(:, 6), obj.band(:, 11), cc.frequency.point(k+1));
                    obj.dosTO(k+1) = 3*cc.frequency.point(k+1)^2 / (2*pi^2*obj.gvTO(k+1)^3);
                end
            end
            % 弛豫时间
            for i = 1 : cc.NW
                invSumTao = 0;
                if obj.gvLA(i+1) ~= 0
                    % Umklapp Scattering
                    invTaou = 2*pc.gammaG^2*pc.kb*cc.envTemp ...
                               * cc.frequency.point(i+1)^2/(pc.miu*pc.V0*pc.omegaD);
                    % Boundary Scattering
                    invTaob = obj.gvLA(i+1)/(cc.modelx.face(end) - cc.modelx.face(1));
                    % Combined
                    invSumTao = invSumTao + invTaou + invTaob;
                    obj.taoLA(i+1) = 1/invSumTao;
                end
                invSumTao = 0;
                if obj.gvTA(i+1) ~= 0
                    invTaou = 2*pc.gammaG^2*pc.kb*cc.envTemp ...
                               * cc.frequency.point(i+1)^2/(pc.miu*pc.V0*pc.omegaD);
                    invTaob = obj.gvTA(i+1)/(cc.modelx.face(end) - cc.modelx.face(1));
                    invSumTao = invSumTao + invTaou + invTaob;
                    obj.taoTA(i+1) = 1/invSumTao;
                end
                invSumTao = 0;
                if obj.gvLO(i+1) ~= 0
                    invTaou = 2*pc.gammaG^2*pc.kb*cc.envTemp ...
                               * cc.frequency.point(i+1)^2/(pc.miu*pc.V0*pc.omegaD);
                    invTaob = obj.gvLO(i+1)/(cc.modelx.face(end) - cc.modelx.face(1));
                    invSumTao = invSumTao + invTaou + invTaob;
                    obj.taoLO(i+1) = 1/invSumTao;
                end
                invSumTao = 0;
                if obj.gvTO(i+1) ~= 0
                    invTaou = 2*pc.gammaG^2*pc.kb*cc.envTemp ...
                               * cc.frequency.point(i+1)^2/(pc.miu*pc.V0*pc.omegaD);
                    invTaob = obj.gvTO(i+1)/(cc.modelx.face(end) - cc.modelx.face(1));
                    invSumTao = invSumTao + invTaou + invTaob;
                    obj.taoTO(i+1) = 1/invSumTao;
                end
            end
        end
        
    end
end
