function computeDirftVelocityWithTime(obj, cc, N)
    %>漂移速度随时间变化
    tic
    cc.timeGrid(0, obj.minimumTime*0.999, N);
    obj.driftVtime = zeros(cc.Nt, 2);
    %>构造索引表
    timeEnd = [0, cc.eField(:, 1)'];
    for t = 1 : cc.Nt
        sumVelocity = 0;
        m = find(cc.eField(:, 1) >= cc.time.face(t), 1);
        for i = 1 : cc.superElecs
            index1 = find(timeEnd(m) <= obj.times(i, :), 1);
            index2 = find(cc.time.face(t) <= obj.times(i, :), 1) - 1;
            if index2 > index1
                sumVelocity = sumVelocity + sum(obj.perdrifts(i, index1:index2)) / (index2 - index1);
            else
                sumVelocity = sumVelocity + obj.perdrifts(i, index1);
            end
        end
        obj.driftVtime(t, 1) = cc.time.point(t + 1) * 1e12;
        obj.driftVtime(t, 2) = sumVelocity / cc.superElecs;
    end
    disp(['漂移速度随时间变化计算完成！耗时：', sprintf('%.2f', toc), ' s'])
end