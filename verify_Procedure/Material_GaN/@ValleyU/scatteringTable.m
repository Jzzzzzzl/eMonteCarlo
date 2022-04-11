function scatteringTable(obj, es, sc, pc, cc)
    %>计算散射表
    %更新散射的句柄函数
    obj.updateScatterringRateFormula(es, pc, cc);
    obj.scatTable(1)  = obj.ionizedImpurity;
    obj.scatTable(2)  = obj.acousticPiezoelectric;
    obj.scatTable(3)  = obj.elasticIntraAcoustic(pc.UD);
    obj.scatTable(4)  = obj.inelasticPolarOpticalAB(sc.wPolarLO);
    obj.scatTable(5)  = obj.inelasticPolarOpticalEM(sc.wPolarLO);
    obj.scatTable(6)  = obj.inelasticInterAB(pc.U2UDK, 6, sc.wU2ULO, (pc.EgU - pc.EgU));
    obj.scatTable(7)  = obj.inelasticInterEM(pc.U2UDK, 6, sc.wU2ULO, (pc.EgU - pc.EgU));
    obj.scatTable(8)  = obj.inelasticInterAB(pc.U2G1DK, 1, sc.wU2GLO, (pc.EgG1 - pc.EgU));
    obj.scatTable(9)  = obj.inelasticInterEM(pc.U2G1DK, 1, sc.wU2GLO, (pc.EgG1 - pc.EgU));
    obj.scatTable(10) = obj.inelasticInterAB(pc.U2G3DK, 1, sc.wU2GLO, (pc.EgG3 - pc.EgU));
    obj.scatTable(11) = obj.inelasticInterEM(pc.U2G3DK, 1, sc.wU2GLO, (pc.EgG3 - pc.EgU));
    %累积求和
    obj.scatTableAll = cumsum(obj.scatTable);
    energys = obj.maxScatRate(:, 1);
    index = find(es.energy <= energys, 1);
    obj.scatTableAll(end) = obj.maxScatRate(index, 2);
end