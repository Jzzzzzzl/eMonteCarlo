function computeAverageEnergyWithTime(obj, cc)
    %>求电子平均能量随时间的变化关系
    tic
    obj.aveETime = zeros(cc.Nt, 1);
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
        obj.aveETime(t) = sumEnergy / num;
    end
    disp(['电子平均能量计算完成！耗时：', sprintf('%.2f', toc), ' s'])
end