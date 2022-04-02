function scatteringRatePlot(dv, sc, pc, cc)
    %>散射率画图
    es = ElectricStatus;
    es.valley = 11;
    dv.valleyGuidingPrinciple(es);
    
    energys = logspace(-3, 1, 100) * pc.e + dv.bs.Eg;
    scatTables = zeros(length(energys), dv.sr.nofScat + 1);
    for i = 1 : length(energys)
        es.energy = energys(i);
        dv.bs.chooseWaveVector(es, pc, randNumber(0, pi));
        dv.bs.computeEnergyAndVelocity(es, pc);
        dv.sr.scatterringTable(dv, es, sc, pc, cc);
        scatTables(i, 1 : end-1) = deal(dv.sr.scatTable');
        scatTables(i, end) = sum(scatTables(i, 1 : end-1));
    end
    figure
    for j = 6 : 9
        slg = semilogy(energys / pc.e, scatTables(:, j));
        slg.LineWidth = 3;
        hold on
    end
    xlabel("eV");
    ylabel("s^{-1}")
%     legend('ionized', 'yadian', 'intra', 'polarxishou', 'polarfashe')
%     legend('UUabLA', 'UUabLO', 'UUemLA', 'UUemLO')
%     legend('UG1abLA', 'UG1abLO', 'UG1emLA', 'UG1emLO')
%     legend('UG3abLA', 'UG3abLO', 'UG3emLA', 'UG3emLO')

%     legend('ionized', 'yadian', 'intra', 'polarxishou', 'polarfashe')
    legend('G1UabLA', 'G1UabLO', 'G1UemLA', 'G1UemLO')
%     legend('G1G3abLA', 'G1G3abLO', 'G1G3emLA', 'G1G3emLO')

%     legend('ionized', 'yadian', 'intra', 'polarxishou', 'polarfashe')
%     legend('G3UabLA', 'G3UabLO', 'G3UemLA', 'G3UemLO')
%     legend('G3G1abLA', 'G3G1abLO', 'G3G1emLA', 'G3G1emLO')
end