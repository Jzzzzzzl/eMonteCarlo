function statisticsWaveVectorDistribution(obj, dv, pc, cc, time)
    %>电子波矢分量分布图
    tic
    es = ElectricStatus;
    cc.waveVectorGrid(-0.4*pc.dBD, 0.4*pc.dBD, 60);
    qVector = zeros(cc.superElecs, 3);
    obj.qNums = zeros(cc.NQ, time(3) + 2);
    for j = 1 : time(3) + 1
        Time = (time(2) - time(1)) * (j - 1) / time(3) + time(1);
        if Time > obj.minTime
            error("超出了最小时间！")
        end
        for i = 1 : cc.superElecs
            index = find(obj.times(i, :) >= Time, 1);
            qVector(i, :) = obj.vectors(1, 1, i, index);
            es.valley = obj.valleys(i, index);
            dv.valleyGuidingPrinciple(es);
            qVector(i, :) = dv.valley.rotateToStandardValley(qVector(i, :), es.valley);
        end
        for k = 1 : cc.NQ
            index = qVector(:, 1) >= cc.vector.face(k) & qVector(:, 1) <= cc.vector.face(k+1);
            obj.qNums(k, 1) = cc.vector.point(k+1);
            obj.qNums(k, j + 1) = sum(double(index));
        end
    end
    disp(['电子波矢分布统计完成！耗时：', sprintf('%.2f', toc), ' s'])
end