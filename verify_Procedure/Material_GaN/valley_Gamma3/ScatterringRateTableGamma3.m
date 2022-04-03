classdef ScatterringRateTableGamma3 < ScatterringRateTableForValley
    %% GammaX能谷散射表
    methods
        function obj = ScatterringRateTableGamma3(pc)
            %>构造函数
            obj.nofScat = pc.nofScatG3;
            obj.maxScatRate = pc.maxScatRateG3;
            obj.xsForimpurity = pc.xsForimpurityG3;
            obj.xsForPolarOptical = pc.xsForPolarOpticalG3;
            obj.scatTable = zeros(obj.nofScat, 1);
        end
        
        function scatterringTable(obj, dv, es, sc, pc, cc)
            %>计算散射表
            %更新散射的句柄函数
            obj.updateScatterringRateFormula(dv, es, pc, cc);
            obj.scatTable(1)  = obj.ionizedImpurityScatRate;
            obj.scatTable(2)  = obj.acousticPiezoelectricScatRate;
            obj.scatTable(3)  = obj.intraAcousticScatRateEM(pc.G3DLA, pc.ul);
            obj.scatTable(4)  = obj.polarOpticalScatRateAB(sc.wPolarLO);
            obj.scatTable(5)  = obj.polarOpticalScatRateEM(sc.wPolarLO);
            obj.scatTable(6)  = obj.interScatRateAB(pc.G32UDK, 1, sc.wU2GLA, (pc.EgU - pc.EgG3));
            obj.scatTable(7)  = obj.interScatRateAB(pc.G32UDK, 1, sc.wU2GLO, (pc.EgU - pc.EgG3));
            obj.scatTable(8)  = obj.interScatRateEM(pc.G32UDK, 1, sc.wU2GLA, (pc.EgU - pc.EgG3));
            obj.scatTable(9)  = obj.interScatRateEM(pc.G32UDK, 1, sc.wU2GLO, (pc.EgU - pc.EgG3));
            obj.scatTable(10) = obj.interScatRateAB(pc.G32G1DK, 1, sc.wG2GLA, (pc.EgG1 - pc.EgG3));
            obj.scatTable(11) = obj.interScatRateAB(pc.G32G1DK, 1, sc.wG2GLO, (pc.EgG1 - pc.EgG3));
            obj.scatTable(12) = obj.interScatRateEM(pc.G32G1DK, 1, sc.wG2GLA, (pc.EgG1 - pc.EgG3));
            obj.scatTable(13) = obj.interScatRateEM(pc.G32G1DK, 1, sc.wG2GLO, (pc.EgG1 - pc.EgG3));
            %累积求和
            obj.scatTableAll = cumsum(obj.scatTable);
            obj.scatTableAll(end) = obj.maxScatRate;
        end
        
    end
end
