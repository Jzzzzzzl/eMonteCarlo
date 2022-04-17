function valleyOccupationWithTime(obj, sh, mm, cc, N)
    %>能谷占据率随时间变化图
    valleys = zeros(cc.superElecs, cc.noFly);
    times = zeros(cc.superElecs, cc.noFly);
    for i = 1 : cc.superElecs
        valleys(i, :) = [sh.eHistory(i, :).valley];
        times(i, :) = [sh.eHistory(i, :).time];
    end
    mm.timeGrid(0, obj.minimumTime, N);
    obj.occupyRate = zeros(mm.Nt, 4);
    for t = 1 : mm.Nt
        num = 0;
        numU = 0;
        numG1 = 0;
        numG3 = 0;
        for i = 1 : cc.superElecs
            index = find(mm.time.face(t) <= times(i, :), 1);
            if isempty(index)
                continue;
            end
            num = num + 1;
            absValley = abs(valleys(i, index));
            if absValley <= 6
                numU = numU + 1;
            elseif absValley == 11
                numG1 = numG1 + 1;
            elseif absValley == 13
                numG3 = numG3 + 1;
            else
                error("能谷标号错误！")
            end
        end
        obj.occupyRate(t, 1) = mm.time.point(t + 1);
        obj.occupyRate(t, 2) = numU / num;
        obj.occupyRate(t, 3) = numG1 / num;
        obj.occupyRate(t, 4) = numG3 / num;
    end
    figure
    hold on
    slg = plot(obj.occupyRate(:, 1)*1e12, obj.occupyRate(:, 2));
    slg(:).LineWidth = 2;
    slg = plot(obj.occupyRate(:, 1)*1e12, obj.occupyRate(:, 3));
    slg(:).LineWidth = 2;
    slg = plot(obj.occupyRate(:, 1)*1e12, obj.occupyRate(:, 4));
    slg(:).LineWidth = 2;
    xlabel("ps");ylabel(".a.u");
    legend('U', 'Gamma1', 'Gamma3')
end