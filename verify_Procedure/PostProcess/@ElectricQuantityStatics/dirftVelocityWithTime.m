function [aveVelocity] = dirftVelocityWithTime(~, sh, mm, cc, t, N)
    %>漂移速度随时间变化
    velocity = zeros(cc.superElecs, cc.noFly);
    times = zeros(cc.superElecs, cc.noFly);
    for i = 1 : cc.superElecs
        velocity(i, :) = [sh.eHistory(i, :).perdrift];
        times(i, :) = [sh.eHistory(i, :).time];
    end
    %计算历史平均速度
    mm.timeGrid(0, t*1e-12, N);
    aveVelocity = zeros(mm.Nt, 2);
    for t = 1 : mm.Nt
        sumVelocity = 0;
        num = 0;
        for i = 1 : cc.superElecs
            index = find(mm.time.face(t) <= times(i, :), 1);
            if isempty(index)
                index = cc.noFly;
            end
            num = num + 1;
            sumVelocity = sumVelocity + sum(velocity(i, 1:index)) / index;
        end
        aveVelocity(t, 1) = mm.time.point(t + 1);
        aveVelocity(t, 2) = sumVelocity / num;
    end

    figure
    slg = plot(aveVelocity(:, 1)*1e12, aveVelocity(:, 2)*100);
    slg.LineWidth = 2;
    xlabel("ps");ylabel("cm/s");
    legend("drift velocity")
end