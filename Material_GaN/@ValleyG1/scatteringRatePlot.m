function scatteringRatePlot(obj, sc, pc, cc, mn)
    %>散射率画图
    es = ElectricStatus;
    es.time = 0;
    es.valley = 11;
    es.position = [0 0 0];
    cc.computePositionParameters(es);
    energys = logspace(-1, 1, 200) * pc.e + obj.Eg;
    scatTables = zeros(length(energys), obj.nofScat + 1);
    for i = 1 : length(energys)
        es.energy = energys(i);
        es.theta = randNumber(0, pi);
        k = obj.generateStandardElectricWaveVector(es, pc);
        es = obj.getGeneralElectricWaveVector(es, pc, k);
        es = obj.computeEnergyAndGroupVelocity(es, pc);
        obj.scatteringTable(es, sc, pc);
        scatTables(i, 1 : end-1) = deal(obj.scatTable');
        scatTables(i, end-1 : end) = deal(obj.scatTableAll(end-1 : end));
    end
    if mn(2) > pc.nofScatG1
        mn(2) = pc.nofScatG1 + 1;
    end
    figure
    for j = mn(1) : mn(2)
        slg = loglog(energys / pc.e, scatTables(:, j));
%         slg = semilogy(energys / pc.e, scatTables(:, j));
        slg.LineWidth = 3;
        hold on
    end
    xlabel("eV");
    ylabel("s^{-1}")
    legends = ["ionized", "piezoelectric", "intravalley", "polarAB", "polarEM", ...
                   "G1UabLO", "G1UemLO", "G1G3abLO", "G1G3emLO", "ALL", "maxScatRate"];
    legend(legends(mn(1) : mn(2)))
end