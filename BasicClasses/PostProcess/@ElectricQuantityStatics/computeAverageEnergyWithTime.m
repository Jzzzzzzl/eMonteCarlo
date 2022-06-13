function computeAverageEnergyWithTime(obj, cc, N)
    %>求电子平均能量随时间的变化关系
    tic
    cc.timeGrid(0, 0.999*obj.minTime, N);
    obj.aveETime = zeros(cc.Nt, 2);
    for t = 1 : cc.Nt
        num = 0;
        sumEnergy = 0;
        for i = 1 : cc.superElecs
            index = find(cc.time.face(t) <= obj.times(i, :), 1);
            if isempty(index)
                continue;
            end
            num = num + 1;
            sumEnergy = sumEnergy + obj.energys(i, index);
        end
        obj.aveETime(t, 1) = cc.time.point(t + 1) * 1e12;
        obj.aveETime(t, 2) = sumEnergy / (num * obj.e);
    end
    disp(['电子平均能量计算完成！耗时：', sprintf('%.2f', toc), ' s'])
end