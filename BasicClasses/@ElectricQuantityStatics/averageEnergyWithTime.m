function averageEnergyWithTime(obj, sh, cc, N)
    %>求电子平均能量随时间的变化关系图
    energy = zeros(cc.superElecs, cc.noFly);
    times = zeros(cc.superElecs, cc.noFly);
    for i = 1 : cc.superElecs
        energy(i, :) = [sh.eHistory(i, :).energy];
        times(i, :) = [sh.eHistory(i, :).time];
    end
    %计算平均能量
    cc.timeGrid(0, obj.minimumTime, N);
    aveEnergy = zeros(cc.Nt, 2);
    for t = 1 : cc.Nt
        sumEnergy = 0;
        num = 0;
        for i = 1 : cc.superElecs
            index = find(cc.time.face(t) <= times(i, :), 1);
            if isempty(index)
                continue;
            end
            num = num + 1;
            sumEnergy = sumEnergy + energy(i, index);
        end
        aveEnergy(t, 1) = cc.time.point(t + 1);
        aveEnergy(t, 2) = sumEnergy / (num * obj.e);
    end
    figure
    slg = plot(aveEnergy(:, 1)*1e12, aveEnergy(:, 2));
    slg.LineWidth = 2;
    xlabel("ps");ylabel("eV");
    legend("average elevtron energy")
end