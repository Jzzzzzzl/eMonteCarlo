function scatteringTable(obj, es, sc, pc)
    %>计算散射表
    %更新散射的句柄函数
    obj.updateScatterringRateFormula(es, pc);
    obj.scatTable = zeros(obj.nofScat, 1);
    obj.scatTableAll = zeros(obj.nofScat, 1);
    obj.scatTable(1)  = obj.ionizedImpurity;
    obj.scatTable(2)  = obj.acousticPiezoelectric;
    obj.scatTable(3)  = obj.elasticIntraAcoustic(pc.G1D);
    obj.scatTable(4)  = obj.inelasticPolarOpticalAB(sc.wPolarLO);
    obj.scatTable(5)  = obj.inelasticPolarOpticalEM(sc.wPolarLO);
    obj.scatTable(6)  = obj.inelasticInterAB(pc.G12UDK, 6, sc.wU2GLO, (pc.EgU - pc.EgG1));
    obj.scatTable(7)  = obj.inelasticInterEM(pc.G12UDK, 6, sc.wU2GLO, (pc.EgU - pc.EgG1));
    obj.scatTable(8) = obj.inelasticInterAB(pc.G12G3DK, 1, sc.wG2GLO, (pc.EgG3 - pc.EgG1));
    obj.scatTable(9) = obj.inelasticInterEM(pc.G12G3DK, 1, sc.wG2GLO, (pc.EgG3 - pc.EgG1));
    %累积求和
    obj.scatTableAll = cumsum(obj.scatTable);
    energys = obj.maxScatRate(:, 1);
    index = find(es.energy <= energys, 1);
    obj.scatTableAll(end) = obj.maxScatRate(index, 2);
end