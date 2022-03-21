classdef ScatterringRateTableGammaX < ScatterringRateTableForValley
    
    methods
        
        function obj = ScatterringRateTableGammaX(pc, cc)
            %能谷参数赋值
            obj.md = pc.mdGX;
            obj.nofScat = cc.nofScatGX;
            obj.maxScatRate = cc.maxScatRateGX;
            obj.scatTable = zeros(obj.nofScat, 1);
            obj.xsForimpurity = cc.xsForimpurityGX;
        end
        
        function scatterringTable(obj, dv, sc, pc, cc)
            % 散射表
            % type = 1---------------ionized-impurity
            % type = 2---------------intra_ab_LA
            % type = 3---------------intra_ab_TA
            % type = 4---------------intra_em_LA
            % type = 5---------------intra_em_TA
            % type = 6---------------inter_g_ab_LA
            % type = 7---------------inter_g_ab_TA
            % type = 8---------------inter_g_ab_LO
            % type = 9---------------inter_f_ab_LA
            % type = 10---------------inter_f_ab_TA
            % type = 11---------------inter_f_ab_TO
            % type = 12--------------inter_g_em_LA
            % type = 13--------------inter_g_em_TA
            % type = 14--------------inter_g_em_LO
            % type = 15--------------inter_f_em_LA
            % type = 16--------------inter_f_em_TA
            % type = 17--------------inter_f_em_TO
            % type = 18--------------selfscatterring
            %更新散射的句柄函数
            obj.updateScatterringRateFormula(dv, pc, cc);
            obj.scatTable(1) = obj.ionizedImpurityScatRate;
            obj.scatTable(2) = obj.intraAcousticScatRateAB(pc.DLA, pc.ul);
            obj.scatTable(3) = obj.intraAcousticScatRateAB(pc.DTA, pc.ut);
            obj.scatTable(4) = obj.intraAcousticScatRateEM(pc.DLA, pc.ul);
            obj.scatTable(5) = obj.intraAcousticScatRateEM(pc.DTA, pc.ut);
            obj.scatTable(6) = obj.interScatRateAB(pc.gDKLA, 1, sc.wgLA, (pc.deltaEpsilongGX - pc.deltaEpsilongGX));
            obj.scatTable(7) = obj.interScatRateAB(pc.gDKTA, 1, sc.wgTA, (pc.deltaEpsilongGX - pc.deltaEpsilongGX));
            obj.scatTable(8) = obj.interScatRateAB(pc.gDKLO, 1, sc.wgLO, (pc.deltaEpsilongGX - pc.deltaEpsilongGX));
            obj.scatTable(9) = obj.interScatRateAB(pc.fDKLA, 4, sc.wfLA, (pc.deltaEpsilongGX - pc.deltaEpsilongGX));
            obj.scatTable(10) = obj.interScatRateAB(pc.fDKTA, 4, sc.wfTA, (pc.deltaEpsilongGX - pc.deltaEpsilongGX));
            obj.scatTable(11) = obj.interScatRateAB(pc.fDKTO, 4, sc.wfTO, (pc.deltaEpsilongGX - pc.deltaEpsilongGX));
            obj.scatTable(12) = obj.interScatRateEM(pc.gDKLA, 1, sc.wgLA, (pc.deltaEpsilongGX - pc.deltaEpsilongGX));
            obj.scatTable(13) = obj.interScatRateEM(pc.gDKTA, 1, sc.wgTA, (pc.deltaEpsilongGX - pc.deltaEpsilongGX));
            obj.scatTable(14) = obj.interScatRateEM(pc.gDKLO, 1, sc.wgLO, (pc.deltaEpsilongGX - pc.deltaEpsilongGX));
            obj.scatTable(15) = obj.interScatRateEM(pc.fDKLA, 4, sc.wfLA, (pc.deltaEpsilongGX - pc.deltaEpsilongGX));
            obj.scatTable(16) = obj.interScatRateEM(pc.fDKTA, 4, sc.wfTA, (pc.deltaEpsilongGX - pc.deltaEpsilongGX));
            obj.scatTable(17) = obj.interScatRateEM(pc.fDKTO, 4, sc.wfTO, (pc.deltaEpsilongGX - pc.deltaEpsilongGX));
            %累积求和
            obj.scatTableAll = cumsum(obj.scatTable);
            obj.scatTableAll(end) = obj.maxScatRate;
        end
        
    end
end