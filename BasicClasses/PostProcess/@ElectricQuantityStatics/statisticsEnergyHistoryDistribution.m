function statisticsEnergyHistoryDistribution(obj, cc, N)
    %>统计电子能量分布
    tic
    scaleNumber = 1.2;
    energysTemp = reshape(obj.energys', [], 1) / obj.e;
    eMax = max(energysTemp) * scaleNumber;
    cc.energyGrid(0, eMax, N);
    obj.eNums = zeros(cc.NE, 2);
    for i = 1 : cc.NE
        index = energysTemp >= cc.energy.face(i) & energysTemp < cc.energy.face(i + 1);
        obj.eNums(i, 1) = cc.energy.point(i + 1);
        obj.eNums(i, 2) = sum(double(index));
    end
    disp(['能量分布统计完成！耗时：', sprintf('%.2f', toc), ' s'])
end