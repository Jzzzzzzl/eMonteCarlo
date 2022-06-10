function computeDriftVelocityWithElectricField(obj, cc)
    %>计算不同电场下的漂移速度
    tic
    if isempty(obj.driftVtime)
        error("请先计算pulsesFieldDirftVelocityWithTime函数！")
    end
    n = find(cc.eField(:, 1) >= obj.minimumTime, 1);
    obj.driftVfield = zeros(n, 2);
    for i = 1 : n
        index = find(obj.driftVtime(:, 1) >= cc.eField(i, 1) * 1e12, 1) - 1;
        if isempty(index)
            [index, ~] = size(obj.driftVtime);
        end
        obj.driftVfield(i, 1) = abs(cc.eField(i, 2));
        obj.driftVfield(i, 2) = obj.driftVtime(index, 2);
    end
    disp(['漂移速度随电场变化关系计算完成！耗时：', sprintf('%.2f', toc), ' s'])
end