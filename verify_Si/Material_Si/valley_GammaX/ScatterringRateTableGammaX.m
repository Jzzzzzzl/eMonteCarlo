classdef ScatterringRateTableGammaX < ScatterringRateTableForValley
    
    methods
        
        function obj = ScatterringRateTableGammaX(pc, cc)
            %能谷参数赋值
            obj.md = pc.md;
            obj.maxScatRate = cc.maxScatRate;
            obj.deltaBandEnergy = pc.deltaBandEnergy;
            %生成散射的句柄函数
            obj.ScatterringRateFomular(pc, cc);
        end
        
        function scatterringTable(obj, es, sc, pc, cc)
            % 散射表
            % type = 1---------------e-impurity
            % type = 2---------------intra_LA
            % type = 3---------------intra_TA
            % type = 4---------------inter_g_ab_TA
            % type = 5---------------inter_g_ab_LA
            % type = 6---------------inter_g_ab_LO
            % type = 7---------------inter_f_ab_TA
            % type = 8---------------inter_f_ab_LA
            % type = 9---------------inter_f_ab_TO
            % type = 10--------------inter_g_em_TA
            % type = 11--------------inter_g_em_LA
            % type = 12--------------inter_g_em_LO
            % type = 13--------------inter_f_em_TA
            % type = 14--------------inter_f_em_LA
            % type = 15--------------inter_f_em_TO
            % type = 16--------------selfscatterring
            obj.scatTable = zeros(cc.nofScat, 1);
            obj.scatTable(1) = obj.impurityScatRate(es.energy, cc.dopDensity);
            obj.scatTable(2) = obj.intraScatRate(es.energy, pc.DLA, pc.ul);
            obj.scatTable(3) = obj.intraScatRate(es.energy, pc.DTA, pc.ut);
            obj.scatTable(4) = obj.interScatRate(es.energy, pc.gDKTA, 1, sc.wgTA, -1);
            obj.scatTable(5) = obj.interScatRate(es.energy, pc.gDKLA, 1, sc.wgLA, -1);
            obj.scatTable(6) = obj.interScatRate(es.energy, pc.gDKLO, 1, sc.wgLO, -1);
            obj.scatTable(7) = obj.interScatRate(es.energy, pc.fDKTA, 4, sc.wfTA, -1);
            obj.scatTable(8) = obj.interScatRate(es.energy, pc.fDKLA, 4, sc.wfLA, -1);
            obj.scatTable(9) = obj.interScatRate(es.energy, pc.fDKTO, 4, sc.wfTO, -1);
            obj.scatTable(10) = obj.interScatRate(es.energy, pc.gDKTA, 1, sc.wgTA, 1);
            obj.scatTable(11) = obj.interScatRate(es.energy, pc.gDKLA, 1, sc.wgLA, 1);
            obj.scatTable(12) = obj.interScatRate(es.energy, pc.gDKLO, 1, sc.wgLO, 1);
            obj.scatTable(13) = obj.interScatRate(es.energy, pc.fDKTA, 4, sc.wfTA, 1);
            obj.scatTable(14) = obj.interScatRate(es.energy, pc.fDKLA, 4, sc.wfLA, 1);
            obj.scatTable(15) = obj.interScatRate(es.energy, pc.fDKTO, 4, sc.wfTO, 1);
            %累积求和
            obj.scatTableAll = cumsum(obj.scatTable);
            obj.scatTableAll(end) = obj.maxScatRate;
        end
        
        function scatterringRatePlot(obj, sc, pc, cc)
            % 散射率画图
            energys = logspace(-3, 1, 100) * pc.e;
            scatTables = zeros(length(energys), cc.nofScat + 1);
            for i = 1 : length(energys)
                es = ElectricStatus;
                es.energy = energys(i);
                obj.scatterringTable(es, sc, pc, cc);
                scatTables(i, 1 : end-1) = deal(obj.scatTable');
                scatTables(i, end) = sum(scatTables(i, 1 : end-1));
            end
            figure
            for j = 1 : cc.nofScat + 1
                slg = loglog(energys / pc.e * 1000, scatTables(:, j));
                slg.LineWidth = 3;
                hold on
            end
            legend("e-impurity","intra LA","intra TA","inter g ab TA","inter g ab LA",...
                      "inter g ab LO","inter f ab TA","inter f ab LA","inter f ab TO",...
                      "inter g em TA","inter g em LA","inter g em LO","inter f em TA",...
                      "inter f em LA","inter f em TO","total")
            xlabel("meV");
            ylabel("s^{-1}")
        end
        
    end
end