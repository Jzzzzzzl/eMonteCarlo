function computeMobilityWithElectricField(obj, cc)
    %>计算迁移率随电场变化图
    tic
    if isempty(obj.mobilityTime)
        error("请先计算computeMobilityWithTime函数！")
    end
    [n, ~] = size(cc.eField);
    obj.mobilityField = zeros(n, 2);
    for i = 1 : n
        index = find(obj.mobilityTime(:, 1) >= cc.eField(i, 1) * 1e12, 1) - 2;
        if isempty(index)
            [index, ~] = size(obj.mobilityTime);
        elseif index < 0
            continue;
        end
        obj.mobilityField(i, 1) = abs(cc.eField(i, 2));
        obj.mobilityField(i, 2) = obj.mobilityTime(index, 2);
    end
    disp(['迁移率随电场变化关系计算完成！耗时：', sprintf('%.2f', toc), ' s'])
end