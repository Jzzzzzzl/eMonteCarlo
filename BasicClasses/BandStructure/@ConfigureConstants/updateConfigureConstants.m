function updateConfigureConstants(obj)
    %>更新被动参数
    %>模型长度计算
    if isscalar(obj.d5)
        obj.mLength = obj.d1 + obj.d2 + obj.d3 + obj.d4 + obj.d5;
    elseif isscalar(obj.d1)
        obj.mLength = obj.d1 + obj.d2 + obj.d3;
    end
    %>势垒/沟道区域坐标
    if obj.relaxLenPB ~= 0
        if obj.NY == 1
            %>一维情况只考虑n++/n+/n++结构
            obj.regionPB = [obj.d1-obj.relaxLenPB obj.d1];
            obj.regionCH = [obj.d1 obj.d1+obj.d2];
            %>构建势垒能量索引
            N = 20;
            obj.energyPB = zeros(N, 2);
            f = @(x) obj.energyPBmax ./ obj.relaxLenPB.^2 .* (x - (obj.d1 - obj.relaxLenPB)).^2;
            obj.energyPB(:, 1) = linspace(obj.d1 - obj.relaxLenPB, obj.d1, N)';
            obj.energyPB(:, 2) = f(obj.energyPB(:, 1));
        else
            %>二维情况只考虑MOS横向结构,包含源/栅/漏结构
            %>但由于不涉及跨区域/跨掺杂,所以不需要复杂设置
            obj.regionPB = [obj.d1+obj.d2+obj.d3-obj.relaxLenPB obj.d1+obj.d2+obj.d3];
            obj.regionCH = [obj.d1+obj.d2+obj.d3 obj.d1+obj.d2+obj.d3+obj.d4];
            %>构建势垒能量索引
            N = 20;
            obj.energyPB = zeros(N, 2);
            obj.energyPB(:, 1) = obj.mLength;
            obj.energyPB(:, 2) = 0;
        end
    else
        %>材料计算
        obj.regionPB = [0 0];
        obj.regionCH = [0 0];
    end
    %>并行任务坐标划分
    obj.assignJobsForParallel;
end