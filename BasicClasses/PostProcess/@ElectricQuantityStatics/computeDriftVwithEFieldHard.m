function computeDriftVwithEFieldHard(obj, cc)
    %>计算不同电场下的漂移速度
    tic
    if isempty(obj.driftVTime)
        error("请先计算漂移速度随时间变化关系！")
    end
    [m, ~] = size(cc.eFieldInput);
    n = find(cc.eFieldInput(:, 1) >= obj.minTime, 1);
    obj.driftVField = zeros(m, 1);
    for i = 1 : n
        index = find(obj.driftVTime(:, 1) >= cc.eFieldInput(i, 1) * 1e12, 1) - 1;
        if isempty(index)
            [index, ~] = size(obj.driftVTime);
        end
        obj.driftVField(i) = obj.driftVTime(index, 2);
    end
    disp(['漂移速度随电场变化关系计算完成！耗时：', sprintf('%.2f', toc), ' s'])
end