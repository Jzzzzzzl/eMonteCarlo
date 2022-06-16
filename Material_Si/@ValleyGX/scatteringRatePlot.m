function scatteringRatePlot(obj, sc, pc, cc, mn)
    %>散射率画图
    es = ElectricStatus;
    es.time = 0;
    es.valley = 1;
    es.position = [0 0 0];
    cc.computePositionParameters(es);
    energys = logspace(-2, 1, 50) * pc.e + obj.Eg;
    scatTables = zeros(length(energys), obj.nofScat + 1);
    for i = 1 : length(energys)
        es.energy = energys(i);
        k = obj.generateStandardElectricWaveVector(es, pc, randNumber(0, pi));
        es = obj.getGeneralElectricWaveVector(es, pc, k);
        es = obj.computeEnergyAndGroupVelocity(es, pc);
        obj.scatteringTable(es, sc, pc);
        scatTables(i, 1 : end-1) = deal(obj.scatTable');
        scatTables(i, end-1 : end) = deal(obj.scatTableAll(end-1 : end));
    end
    if mn(2) > pc.nofScatGX
        mn(2) = pc.nofScatGX + 1;
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
    legends = ["ionized", "intraLAab", "intraTAab", "intraLAem", "intraTAem", ...
                   "intergLAab", "intergTAab", "intergLOab", ...
                   "interfLAab", "interfTAab", "interfTOab"...
                   "intergLAem", "intergTAem", "intergLOem", ...
                   "interfLAem", "interfTAem", "interfTOem", "ALL", "maxScatRate"];
    legend(legends(mn(1) : mn(2)))
end