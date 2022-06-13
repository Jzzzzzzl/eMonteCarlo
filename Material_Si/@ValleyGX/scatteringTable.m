function scatteringTable(obj, es, sc, pc)
    %>计算散射表
    % type = 1---------------ionized-impurity
    % type = 2---------------intra_ab_LA
    % type = 3---------------intra_ab_TA
    % type = 4---------------intra_em_LA
    % type = 5---------------intra_em_TA
    % type = 6---------------inter_g_ab_LA
    % type = 7---------------inter_g_ab_TA
    % type = 8---------------inter_g_ab_LO
    % type = 9---------------inter_f_ab_LA
    % type = 10--------------inter_f_ab_TA
    % type = 11--------------inter_f_ab_TO
    % type = 12--------------inter_g_em_LA
    % type = 13--------------inter_g_em_TA
    % type = 14--------------inter_g_em_LO
    % type = 15--------------inter_f_em_LA
    % type = 16--------------inter_f_em_TA
    % type = 17--------------inter_f_em_TO
    % type = 18--------------selfscatterring
    %更新散射的句柄函数
    obj.updateScatterringRateFormula(es, pc);
    obj.scatTable(1) = obj.ionizedImpurity;
    obj.scatTable(2) = obj.inelasticIntraAcousticAB(pc.DLA);
    obj.scatTable(3) = obj.inelasticIntraAcousticAB(pc.DTA);
    obj.scatTable(4) = obj.inelasticIntraAcousticEM(pc.DLA);
    obj.scatTable(5) = obj.inelasticIntraAcousticEM(pc.DTA);
    obj.scatTable(6) = obj.inelasticInterAB(pc.gDKLA, 1, sc.wg.LA, (pc.EgGX - pc.EgGX));
    obj.scatTable(7) = obj.inelasticInterAB(pc.gDKTA, 1, sc.wg.TA, (pc.EgGX - pc.EgGX));
    obj.scatTable(8) = obj.inelasticInterAB(pc.gDKLO, 1, sc.wg.LO, (pc.EgGX - pc.EgGX));
    obj.scatTable(9) = obj.inelasticInterAB(pc.fDKLA, 4, sc.wf.LA, (pc.EgGX - pc.EgGX));
    obj.scatTable(10) = obj.inelasticInterAB(pc.fDKTA, 4, sc.wf.TA, (pc.EgGX - pc.EgGX));
    obj.scatTable(11) = obj.inelasticInterAB(pc.fDKTO, 4, sc.wf.TO, (pc.EgGX - pc.EgGX));
    obj.scatTable(12) = obj.inelasticInterEM(pc.gDKLA, 1, sc.wg.LA, (pc.EgGX - pc.EgGX));
    obj.scatTable(13) = obj.inelasticInterEM(pc.gDKTA, 1, sc.wg.TA, (pc.EgGX - pc.EgGX));
    obj.scatTable(14) = obj.inelasticInterEM(pc.gDKLO, 1, sc.wg.LO, (pc.EgGX - pc.EgGX));
    obj.scatTable(15) = obj.inelasticInterEM(pc.fDKLA, 4, sc.wf.LA, (pc.EgGX - pc.EgGX));
    obj.scatTable(16) = obj.inelasticInterEM(pc.fDKTA, 4, sc.wf.TA, (pc.EgGX - pc.EgGX));
    obj.scatTable(17) = obj.inelasticInterEM(pc.fDKTO, 4, sc.wf.TO, (pc.EgGX - pc.EgGX));
    %累积求和
    obj.scatTableAll = cumsum(obj.scatTable);
    energys = obj.maxScatRate(:, 1);
    index = find(es.energy <= energys, 1);
    obj.scatTableAll(end) = obj.maxScatRate(index, 2);
end