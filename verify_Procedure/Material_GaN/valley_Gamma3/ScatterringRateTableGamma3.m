classdef ScatterringRateTableGamma3 < ScatterringRateTableForValley
    %% Gamma3能谷散射表
    methods
        function obj = ScatterringRateTableGamma3(pc)
            %>构造函数
            obj.nofScat = pc.nofScatG3;
            obj.maxScatRate = pc.maxScatRateG3;
            obj.xsForimpurity = pc.xsForimpurityG3;
            obj.xsForPolarOptical = pc.xsForPolarOpticalG3;
            obj.scatTable = zeros(obj.nofScat, 1);
        end
        
        function updateScatterringRateFormula(obj, dv, es, pc, cc)
            %>更新散射率句柄函数
            obj.ionizedImpurityScatteringRate(dv, es, pc, cc);
            obj.acousticPiezoelectricScatteringRate(dv, es, pc, cc);
            obj.elasticIntravalleyAcousticScatteringRate(dv, es, pc, cc);
            obj.inelasticPolarOpticalScatteringRate(dv, es, pc, cc);
            obj.inelasticIntervalleyScatteringRate(dv, es, pc, cc);
        end
        
        function scatterringTable(obj, dv, es, sc, pc, cc)
            %>计算散射表
            %更新散射的句柄函数
            obj.updateScatterringRateFormula(dv, es, pc, cc);
            obj.scatTable(1)  = obj.ionizedImpurity;
            obj.scatTable(2)  = obj.acousticPiezoelectric;
            obj.scatTable(3)  = obj.elasticIntraAcoustic(pc.G3D);
            obj.scatTable(4)  = obj.inelasticPolarOpticalAB(sc.wPolarLO);
            obj.scatTable(5)  = obj.inelasticPolarOpticalEM(sc.wPolarLO);
            obj.scatTable(6)  = obj.inelasticInterAB(pc.G32UDK, 6, sc.wU2GLA, (pc.EgU - pc.EgG3));
            obj.scatTable(7)  = obj.inelasticInterAB(pc.G32UDK, 6, sc.wU2GLO, (pc.EgU - pc.EgG3));
            obj.scatTable(8)  = obj.inelasticInterEM(pc.G32UDK, 6, sc.wU2GLA, (pc.EgU - pc.EgG3));
            obj.scatTable(9)  = obj.inelasticInterEM(pc.G32UDK, 6, sc.wU2GLO, (pc.EgU - pc.EgG3));
            obj.scatTable(10) = obj.inelasticInterAB(pc.G32G1DK, 1, sc.wG2GLA, (pc.EgG1 - pc.EgG3));
            obj.scatTable(11) = obj.inelasticInterAB(pc.G32G1DK, 1, sc.wG2GLO, (pc.EgG1 - pc.EgG3));
            obj.scatTable(12) = obj.inelasticInterEM(pc.G32G1DK, 1, sc.wG2GLA, (pc.EgG1 - pc.EgG3));
            obj.scatTable(13) = obj.inelasticInterEM(pc.G32G1DK, 1, sc.wG2GLO, (pc.EgG1 - pc.EgG3));
            %累积求和
            obj.scatTableAll = cumsum(obj.scatTable);
%             obj.scatTableAll(end) = obj.maxScatRate;
        end
        
    end
end
