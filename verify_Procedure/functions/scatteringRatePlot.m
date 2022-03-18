function scatteringRatePlot(dv, sc, pc, cc)
    % 散射率画图
    es = ElectricStatus;
    es.valley = 1;
    dv.judgeBsSrSp(es);
    
    energys = logspace(-5, 2, 100) * pc.e;
    scatTables = zeros(length(energys), dv.sr.nofScat + 1);
    for i = 1 : length(energys)
        es.energy = energys(i);
        dv.sr.scatterringTable(es, dv, sc, pc, cc);
        scatTables(i, 1 : end-1) = deal(dv.sr.scatTable');
        scatTables(i, end) = sum(scatTables(i, 1 : end-1));
    end
    figure
    for j = 1 : dv.sr.nofScat + 1
        slg = loglog(energys / pc.e * 1000, scatTables(:, j));
        slg.LineWidth = 3;
        hold on
    end
%             legend("e-impurity","intra LA","intra TA","inter g ab TA","inter g ab LA",...
%                       "inter g ab LO","inter f ab TA","inter f ab LA","inter f ab TO",...
%                       "inter g em TA","inter g em LA","inter g em LO","inter f em TA",...
%                       "inter f em LA","inter f em TO","total")
    xlabel("meV");
    ylabel("s^{-1}")
end