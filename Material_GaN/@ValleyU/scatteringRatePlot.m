function scatteringRatePlot(obj, sc, pc, cc, mn)
    %>散射率画图
    es = ElectricStatus;
    es.position = [0 0 0];
    es.valley = 1;
    num = 50;
    energys = logspace(-1, 1, num) * pc.e + obj.Eg;
    scatTables = zeros(length(energys), obj.nofScat);
    for i = 1 : length(energys)
        es.energy = energys(i);
        k = obj.generateStandardElectricWaveVector(es, pc, randNumber(0, pi));
        es = obj.getGeneralElectricWaveVector(es, pc, k);
        es = obj.computeEnergyAndGroupVelocity(es, pc);
        obj.scatteringTable(es, sc, pc, cc);
        scatTables(i, :) = deal(obj.scatTable');
        scatTables(i, end) = deal(obj.scatTableAll(end));
    end
    if mn(2) > pc.nofScatU; mn(2) = pc.nofScatU; end
    figure
    for j = mn(1) : mn(2)
%         slg = loglog(energys / pc.e, scatTables(:, j));
        slg = semilogy(energys / pc.e, scatTables(:, j));
        slg.LineWidth = 3;
        hold on
    end
    xlabel("eV");
    ylabel("s^{-1}")
    legends = ["ionized", "piezoelectric", "intravalley", "polarAB", "polarEM", ...
                    "UUabLO", "UUemLO", "UG1abLO", "UG1emLO", ...
                    "UG3abLO", "UG3emLO", "ALL"];
    legend(legends(mn(1) : mn(2)))
end