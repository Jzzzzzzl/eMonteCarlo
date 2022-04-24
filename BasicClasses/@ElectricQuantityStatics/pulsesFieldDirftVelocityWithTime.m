function pulsesFieldDirftVelocityWithTime(obj, sh, cc, N)
    %>漂移速度随时间变化
    velocity = zeros(cc.superElecs, cc.noFly);
    times = zeros(cc.superElecs, cc.noFly);
    for i = 1 : cc.superElecs
        velocity(i, :) = [sh.eHistory(i, :).perdrift];
        times(i, :) = [sh.eHistory(i, :).time];
    end
    %计算历史平均漂移速度
    cc.timeGrid(0, obj.minimumTime*0.999, N);
    obj.aveDriftVelocity = zeros(cc.Nt, 2);
    %构造索引表
    timeEnd = [0, cc.eField(:, 1)'];
    for t = 1 : cc.Nt
        sumVelocity = 0;
        m = find(cc.eField(:, 1) >= cc.time.face(t), 1);
        for i = 1 : cc.superElecs
            index1 = find(timeEnd(m) <= times(i, :), 1);
            index2 = find(cc.time.face(t) <= times(i, :), 1) - 1;
            if index2 > index1
                sumVelocity = sumVelocity + sum(velocity(i, index1:index2)) / (index2 - index1);
            else
                sumVelocity = sumVelocity + velocity(i, index1);
            end
        end
        obj.aveDriftVelocity(t, 1) = cc.time.point(t + 1);
        obj.aveDriftVelocity(t, 2) = sumVelocity / cc.superElecs;
    end
    figure
    slg = plot(obj.aveDriftVelocity(:, 1)*1e12, obj.aveDriftVelocity(:, 2)*100);
    slg.LineWidth = 2;
    xlabel("ps");ylabel("cm/s");
    legend("drift velocity")
end