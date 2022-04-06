function scatteringRatePlot(dv, sc, pc, cc)
    %>散射率画图
    es = ElectricStatus;
    es.valley = 11;
    dv.valleyGuidingPrinciple(es);
    num = 50;
    energys = logspace(-1, 1, num) * pc.e + dv.bs.Eg;
    scatTables = zeros(length(energys), dv.sr.nofScat);
    for i = 1 : length(energys)
        es.energy = energys(i);
        dv.bs.chooseElectricWaveVector(es, pc, randNumber(0, pi));
        dv.bs.computeEnergyAndGroupVelocity(es, pc);
        dv.sr.scatterringTable(dv, es, sc, pc, cc);
        scatTables(i, :) = deal(dv.sr.scatTable');
        scatTables(i, end) = deal(dv.sr.scatTableAll(end));
    end
    figure
    for j = 1 : 14
        slg = loglog(energys / pc.e, scatTables(:, j));
%         slg = semilogy(energys / pc.e, scatTables(:, j));
        slg.LineWidth = 3;
        hold on
    end
    xlabel("eV");
    ylabel("s^{-1}")
    %U
%     legend('ionized', 'yadian', 'intra', 'polarxishou', 'polarfashe')
%     legend('UUabLA', 'UUabLO', 'UUemLA', 'UUemLO')
%     legend('UG1abLA', 'UG1abLO', 'UG1emLA', 'UG1emLO')
%     legend('UG3abLA', 'UG3abLO', 'UG3emLA', 'UG3emLO')
    %Gamma1
%     legend('ionized', 'yadian', 'intra', 'polarxishou', 'polarfashe')
%     legend('G1UabLA', 'G1UabLO', 'G1UemLA', 'G1UemLO')
%     legend('G1G3abLA', 'G1G3abLO', 'G1G3emLA', 'G1G3emLO')
    %Gamma3
%     legend('ionized', 'yadian', 'intra', 'polarxishou', 'polarfashe')
%     legend('G3UabLA', 'G3UabLO', 'G3UemLA', 'G3UemLO')
%     legend('G3G1abLA', 'G3G1abLO', 'G3G1emLA', 'G3G1emLO')
end