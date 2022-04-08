function scatteringTable(obj, es, sc, pc, cc)
    %>计算散射表
    %更新散射的句柄函数
    obj.updateScatterringRateFormula(es, pc, cc);
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
    energys = obj.maxScatRate(:, 1);
    index = find(es.energy <= energys, 1);
    obj.scatTableAll(end) = obj.maxScatRate(index, 2);
end