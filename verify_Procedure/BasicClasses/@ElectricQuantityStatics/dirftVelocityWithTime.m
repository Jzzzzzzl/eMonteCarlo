function dirftVelocityWithTime(obj, sh, mm, cc, N)
    %>漂移速度随时间变化
    velocity = zeros(cc.superElecs, cc.noFly);
    times = zeros(cc.superElecs, cc.noFly);
    for i = 1 : cc.superElecs
        velocity(i, :) = [sh.eHistory(i, :).perdrift];
        times(i, :) = [sh.eHistory(i, :).time];
    end
    %计算历史平均速度
    mm.timeGrid(0, obj.minimumTime*0.999, N);
    obj.aveDriftVelocity = zeros(mm.Nt, 2);
    for t = 1 : mm.Nt
        sumVelocity = 0;
        for i = 1 : cc.superElecs
            index = find(mm.time.face(t) <= times(i, :), 1);
            sumVelocity = sumVelocity + sum(velocity(i, 1:index)) / index;
        end
        obj.aveDriftVelocity(t, 1) = mm.time.point(t + 1);
        obj.aveDriftVelocity(t, 2) = sumVelocity / cc.superElecs;
    end
    
    figure
    slg = plot(obj.aveDriftVelocity(:, 1)*1e12, obj.aveDriftVelocity(:, 2)*100);
    slg.LineWidth = 2;
    xlabel("ps");ylabel("cm/s");
    legend("drift velocity")
end