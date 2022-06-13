function computeMobilityWithElectricField(obj, cc)
    %>计算迁移率随电场变化
    tic
    if isempty(obj.mobTime)
        error("请先计算迁移率随时间变化关系！")
    end
    n = find(cc.eFieldInput(:, 1) >= obj.minTime, 1);
    obj.mobField = zeros(n, 2);
    for i = 1 : n
        index = find(obj.mobTime(:, 1) >= cc.eFieldInput(i, 1) * 1e12, 1) - 1;
        if isempty(index)
            [index, ~] = size(obj.mobTime);
        end
        obj.mobField(i, 1) = abs(cc.eFieldInput(i, 2));
        obj.mobField(i, 2) = obj.mobTime(index, 2);
    end
    disp(['迁移率随电场变化关系计算完成！耗时：', sprintf('%.2f', toc), ' s'])
end