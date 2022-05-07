function computeDiffusionCoefficientWithElectricField(obj, cc)
    %>计算不同电场下的扩散系数
    tic
    if isempty(obj.diffusionCoe)
        error("请先计算computeDiffusionCoefficientWithTime函数！")
    end
    n = find(cc.eField(:, 1) >= obj.minimumTime, 1);
    obj.diffusionField = zeros(n, 2);
    for i = 1 : n
        index = find(obj.diffusionCoe(:, 1) >= cc.eField(i, 1) * 1e12, 1) - 2;
        if isempty(index)
            [index, ~] = size(obj.diffusionCoe);
        end
        obj.diffusionField(i, 1) = abs(cc.eField(i, 2));
        obj.diffusionField(i, 2) = obj.diffusionCoe(index, 2);
    end
    disp(['扩散系数随电场变化关系计算完成！耗时：', sprintf('%.2f', toc), ' s'])
end