function scatteringTable(obj, es, sc, pc)
    %>计算散射表
    %更新散射的句柄函数
    obj.updateScatterringRateFormula(es, pc);
    obj.scatTable(1) = obj.ionizedImpurity;
    obj.scatAngle(1) = obj.thetaIImpu;
    obj.scatTable(2) = obj.acousticPiezoelectric;
    obj.scatAngle(2) = obj.thetaAPiezo;
    obj.scatTable(3) = obj.elasticIntraAcoustic(pc.UD);
    obj.scatAngle(3) = randNumber(0, pi);
    obj.scatTable(4) = obj.inelasticPolarOpticalAB(sc.wPolarLO);
    obj.scatAngle(4) = obj.thetaPOab(sc.wPolarLO);
    obj.scatTable(5) = obj.inelasticPolarOpticalEM(sc.wPolarLO);
    obj.scatAngle(5) = obj.thetaPOem(sc.wPolarLO);
    obj.scatTable(6) = obj.inelasticInterAB(pc.U2UDK, 6, sc.wU2ULO, (pc.EgU - pc.EgU));
    obj.scatAngle(6) = randNumber(0, pi);
    obj.scatTable(7) = obj.inelasticInterEM(pc.U2UDK, 6, sc.wU2ULO, (pc.EgU - pc.EgU));
    obj.scatAngle(7) = randNumber(0, pi);
    obj.scatTable(8) = obj.inelasticInterAB(pc.U2G1DK, 1, sc.wU2GLO, (pc.EgG1 - pc.EgU));
    obj.scatAngle(8) = randNumber(0, pi);
    obj.scatTable(9) = obj.inelasticInterEM(pc.U2G1DK, 1, sc.wU2GLO, (pc.EgG1 - pc.EgU));
    obj.scatAngle(9) = randNumber(0, pi);
    obj.scatTable(10) = obj.inelasticInterAB(pc.U2G3DK, 1, sc.wU2GLO, (pc.EgG3 - pc.EgU));
    obj.scatAngle(10) = randNumber(0, pi);
    obj.scatTable(11) = obj.inelasticInterEM(pc.U2G3DK, 1, sc.wU2GLO, (pc.EgG3 - pc.EgU));
    obj.scatAngle(11) = randNumber(0, pi);
    obj.scatAngle(12) = 0;
    %累积求和
    obj.scatTableAll = cumsum(obj.scatTable);
    energys = obj.maxScatRate(:, 1);
    index = find(es.energy <= energys, 1);
    obj.scatTableAll(end) = obj.maxScatRate(index, 2);
end