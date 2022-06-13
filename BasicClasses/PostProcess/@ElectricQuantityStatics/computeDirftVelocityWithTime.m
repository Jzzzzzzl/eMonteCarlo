function computeDirftVelocityWithTime(obj, cc, N)
    %>计算漂移速度随时间变化
    tic
    cc.timeGrid(0, obj.minTime*0.999, N);
    obj.driftVTime = zeros(cc.Nt, 2);
    try
        %>统计不同电场下电子平均漂移速度
        %>构造索引表
        timeEnd = [0, cc.eFieldInput(:, 1)'];
        for t = 1 : cc.Nt
            sumVelocity = 0;
            m = find(cc.eFieldInput(:, 1) >= cc.time.face(t), 1);
            for i = 1 : cc.superElecs
                index1 = find(timeEnd(m) <= obj.times(i, :), 1);
                index2 = find(cc.time.face(t) <= obj.times(i, :), 1) - 1;
                if index2 > index1
                    sumVelocity = sumVelocity + sum(obj.perdrifts(i, index1:index2)) / (index2 - index1);
                else
                    sumVelocity = sumVelocity + obj.perdrifts(i, index1);
                end
            end
            obj.driftVTime(t, 1) = cc.time.point(t + 1) * 1e12;
            obj.driftVTime(t, 2) = sumVelocity / cc.superElecs;
        end
    catch
        %>统计一般情况下的电子平均漂移速度
        for t = 1 : cc.Nt
            num = 0;
            sumAvev = 0;
            for i = 1 : cc.superElecs
                index = find(cc.time.face(t) <= obj.times(i, :), 1);
                if isempty(index)
                    continue;
                end
                num = num + 1;
                sumAvev = sumAvev + obj.perdrifts(i, index);
            end
            obj.driftVTime(t, 1) = cc.time.point(t + 1) * 1e12;
            obj.driftVTime(t, 2) = sumAvev / num;
        end
    end
    disp(['漂移速度随时间变化计算完成！耗时：', sprintf('%.2f', toc), ' s'])
end