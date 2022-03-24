function scatteringRatePlot(dv, sc, pc, cc)
    %>散射率画图
    es = ElectricStatus;
    es.valley = 1;
    dv.valleyGuidingPrinciple(es);
    
    energys = logspace(-3, 1, 100) * pc.e;
    scatTables = zeros(length(energys), dv.sr.nofScat + 1);
    for i = 1 : length(energys)
        es.energy = energys(i);
        dv.bs.chooseWaveVector(es, pc);
        dv.bs.computeEnergyAndVelocity(es, pc);
        dv.sr.updateScatterringRateFormula(dv, pc, cc);
        dv.sr.scatterringTable(dv, sc, pc, cc);
        scatTables(i, 1 : end-1) = deal(dv.sr.scatTable');
        scatTables(i, end) = sum(scatTables(i, 1 : end-1));
    end
    figure
    for j = 1 : dv.sr.nofScat + 1
        slg = loglog(energys / pc.e * 1000, scatTables(:, j));
        slg.LineWidth = 3;
        hold on
    end
    xlabel("meV");
    ylabel("s^{-1}")
end