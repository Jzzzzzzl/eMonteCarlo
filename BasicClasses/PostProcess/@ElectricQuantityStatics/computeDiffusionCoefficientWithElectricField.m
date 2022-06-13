function computeDiffusionCoefficientWithElectricField(obj, cc)
    %>计算不同电场下的扩散系数
    tic
    if isempty(obj.dcoTime)
        error("请先计算扩散系数随时间变化！")
    end
    n = find(cc.eFieldInput(:, 1) >= obj.minTime, 1);
    obj.dcoField = zeros(n, 2);
    for i = 1 : n
        index = find(obj.dcoTime(:, 1) >= cc.eFieldInput(i, 1) * 1e12, 1) - 1;
        if isempty(index)
            [index, ~] = size(obj.dcoTime);
        end
        obj.dcoField(i, 1) = abs(cc.eFieldInput(i, 2));
        obj.dcoField(i, 2) = obj.dcoTime(index, 2);
    end
    disp(['扩散系数随电场变化关系计算完成！耗时：', sprintf('%.2f', toc), ' s'])
end