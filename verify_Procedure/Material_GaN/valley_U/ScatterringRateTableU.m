classdef ScatterringRateTableU < ScatterringRateTableForValley
    %% U能谷散射表
    methods
        function obj = ScatterringRateTableU(pc)
            %>构造函数
            obj.nofScat = pc.nofScatU;
            obj.maxScatRate = pc.maxScatRateU;
            obj.xsForimpurity = pc.xsForimpurityU;
            obj.xsForPolarOptical = pc.xsForPolarOpticalU;
            obj.scatTable = zeros(obj.nofScat, 1);
        end
        
        function scatterringTable(obj, dv, es, sc, pc, cc)
            %>计算散射表
            %更新散射的句柄函数
            obj.updateScatterringRateFormula(dv, es, pc, cc);
            obj.scatTable(1)  = obj.ionizedImpurity;
            obj.scatTable(2)  = obj.acousticPiezoelectric;
            obj.scatTable(3)  = obj.elasticIntraAcoustic(pc.UD);
            obj.scatTable(4)  = obj.inelasticPolarOpticalAB(sc.wPolarLO);
            obj.scatTable(5)  = obj.inelasticPolarOpticalEM(sc.wPolarLO);
            obj.scatTable(6)  = obj.inelasticInterAB(pc.U2UDK, 1, sc.wU2ULA, (pc.EgU - pc.EgU));
            obj.scatTable(7)  = obj.inelasticInterAB(pc.U2UDK, 1, sc.wU2ULO, (pc.EgU - pc.EgU));
            obj.scatTable(8)  = obj.inelasticInterEM(pc.U2UDK, 1, sc.wU2ULA, (pc.EgU - pc.EgU));
            obj.scatTable(9)  = obj.inelasticInterEM(pc.U2UDK, 1, sc.wU2ULO, (pc.EgU - pc.EgU));
            obj.scatTable(10) = obj.inelasticInterAB(pc.U2G1DK, 1, sc.wU2GLA, (pc.EgG1 - pc.EgU));
            obj.scatTable(11) = obj.inelasticInterAB(pc.U2G1DK, 1, sc.wU2GLO, (pc.EgG1 - pc.EgU));
            obj.scatTable(12) = obj.inelasticInterEM(pc.U2G1DK, 1, sc.wU2GLA, (pc.EgG1 - pc.EgU));
            obj.scatTable(13) = obj.inelasticInterEM(pc.U2G1DK, 1, sc.wU2GLO, (pc.EgG1 - pc.EgU));
            obj.scatTable(14) = obj.inelasticInterAB(pc.U2G3DK, 1, sc.wU2GLA, (pc.EgG3 - pc.EgU));
            obj.scatTable(15) = obj.inelasticInterAB(pc.U2G3DK, 1, sc.wU2GLO, (pc.EgG3 - pc.EgU));
            obj.scatTable(16) = obj.inelasticInterEM(pc.U2G3DK, 1, sc.wU2GLA, (pc.EgG3 - pc.EgU));
            obj.scatTable(17) = obj.inelasticInterEM(pc.U2G3DK, 1, sc.wU2GLO, (pc.EgG3 - pc.EgU));
            %累积求和
            obj.scatTableAll = cumsum(obj.scatTable);
            obj.scatTableAll(end) = obj.scatTableAll(end-1);
%             obj.scatTableAll(end) = obj.maxScatRate;
        end
        
    end
end