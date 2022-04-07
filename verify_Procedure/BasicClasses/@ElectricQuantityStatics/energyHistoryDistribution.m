function [enumber] = energyHistoryDistribution(obj, sh, mm, cc, e, N)
    %>电子能量分布
    energys = zeros(cc.superElecs, cc.noFly);
    for i = 1 : cc.superElecs
        energys(i, :) = [sh.eHistory(i, :).energy] / obj.e;
    end
    energys = reshape(energys', [], 1);
    mm.energyGrid(0, e, N);
    enumber = zeros(mm.NE, 2);
    for i = 1 : mm.NE
        index = energys >= mm.energy.face(i) & energys < mm.energy.face(i + 1);
        enumber(i, 1) = mm.energy.point(i + 1);
        enumber(i, 2) = sum(double(index));
    end
    figure
    bar(enumber(:,1), enumber(:,2));
    xlabel("electron energy(eV)");
    legend("Electron Energy Distribution");
end