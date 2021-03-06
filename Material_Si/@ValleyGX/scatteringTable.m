function scatteringTable(obj, es, sc, pc)
    %>计算散射表
    % type = 1----------------ionized-impurity
    % type = 2----------------intra_ab_LA
    % type = 3----------------intra_ab_TA
    % type = 4----------------inter_f_ab_LA
    % type = 5----------------inter_f_ab_TA
    % type = 6----------------inter_f_ab_TO
    % type = 7----------------inter_g_ab_LA
    % type = 8----------------inter_g_ab_TA
    % type = 9----------------inter_g_ab_LO
    % type = 10--------------intra_em_LA
    % type = 11--------------intra_em_TA
    % type = 12--------------inter_f_em_LA
    % type = 13--------------inter_f_em_TA
    % type = 14--------------inter_f_em_TO
    % type = 15--------------inter_g_em_LA
    % type = 16--------------inter_g_em_TA
    % type = 17--------------inter_g_em_LO
    % type = 18--------------selfscatterring
    %更新散射的句柄函数
    obj.updateScatterringRateFormula(es, pc);
    obj.scatTable(1) = obj.ionizedImpurity;
    obj.scatAngle(1) = obj.thetaIImpu;
    obj.scatTable(2) = obj.inelasticIntraAcousticAB(pc.DLA);
    obj.scatAngle(2) = randNumber(0, pi);
    obj.scatTable(3) = obj.inelasticIntraAcousticAB(pc.DTA);
    obj.scatAngle(3) = randNumber(0, pi);
    obj.scatTable(4) = obj.inelasticInterAB(pc.fDKLA, 4, sc.wf.LA, (pc.EgGX - pc.EgGX));
    obj.scatAngle(4) = randNumber(0, pi);
    obj.scatTable(5) = obj.inelasticInterAB(pc.fDKTA, 4, sc.wf.TA, (pc.EgGX - pc.EgGX));
    obj.scatAngle(5) = randNumber(0, pi);
    obj.scatTable(6) = obj.inelasticInterAB(pc.fDKTO, 4, sc.wf.TO, (pc.EgGX - pc.EgGX));
    obj.scatAngle(6) = randNumber(0, pi);
    obj.scatTable(7) = obj.inelasticInterAB(pc.gDKLA, 1, sc.wg.LA, (pc.EgGX - pc.EgGX));
    obj.scatAngle(7) = randNumber(0, pi);
    obj.scatTable(8) = obj.inelasticInterAB(pc.gDKTA, 1, sc.wg.TA, (pc.EgGX - pc.EgGX));
    obj.scatAngle(8) = randNumber(0, pi);
    obj.scatTable(9) = obj.inelasticInterAB(pc.gDKLO, 1, sc.wg.LO, (pc.EgGX - pc.EgGX));
    obj.scatAngle(9) = randNumber(0, pi);
    obj.scatTable(10) = obj.inelasticIntraAcousticEM(pc.DLA);
    obj.scatAngle(10) = randNumber(0, pi);
    obj.scatTable(11) = obj.inelasticIntraAcousticEM(pc.DTA);
    obj.scatAngle(11) = randNumber(0, pi);
    obj.scatTable(12) = obj.inelasticInterEM(pc.fDKLA, 4, sc.wf.LA, (pc.EgGX - pc.EgGX));
    obj.scatAngle(12) = randNumber(0, pi);
    obj.scatTable(13) = obj.inelasticInterEM(pc.fDKTA, 4, sc.wf.TA, (pc.EgGX - pc.EgGX));
    obj.scatAngle(13) = randNumber(0, pi);
    obj.scatTable(14) = obj.inelasticInterEM(pc.fDKTO, 4, sc.wf.TO, (pc.EgGX - pc.EgGX));
    obj.scatAngle(14) = randNumber(0, pi);
    obj.scatTable(15) = obj.inelasticInterEM(pc.gDKLA, 1, sc.wg.LA, (pc.EgGX - pc.EgGX));
    obj.scatAngle(15) = randNumber(0, pi);
    obj.scatTable(16) = obj.inelasticInterEM(pc.gDKTA, 1, sc.wg.TA, (pc.EgGX - pc.EgGX));
    obj.scatAngle(16) = randNumber(0, pi);
    obj.scatTable(17) = obj.inelasticInterEM(pc.gDKLO, 1, sc.wg.LO, (pc.EgGX - pc.EgGX));
    obj.scatAngle(17) = randNumber(0, pi);
    obj.scatAngle(18) = 0;
    %累积求和
    obj.scatTableAll = cumsum(obj.scatTable);
    energys = obj.maxScatRate(:, 1);
    index = find(es.energy <= energys, 1);
    obj.scatTableAll(end) = obj.maxScatRate(index, 2);
end