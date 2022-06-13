function computeDiffusionCoefficientWithTime(obj, cc, N)
    %>计算扩散系数随时间变化关系
    tic
    cc.timeGrid(0, 0.999*obj.minTime, N);
    obj.dcoTime = zeros(cc.Nt, 2);
    %>构造索引表
    timeEnd = [0, cc.eFieldInput(:, 1)'];
    for t = 1 : cc.Nt
        diffusion = zeros(cc.superElecs, 1);
        m = find(cc.eFieldInput(:, 1) >= cc.time.face(t), 1);
        for i = 1 : cc.superElecs
            index1 = find(timeEnd(m) <= obj.times(i, :), 1);
            index2 = find(cc.time.face(t) <= obj.times(i, :), 1) - 1;
            sum2ave = 0;
            sumave2 = 0;
            if index2 > index1
                for j = index1 : index2
                    positionVector = obj.positions(:, :, i, j);
                    sumave2 = sumave2 + positionVector(1);
                    sum2ave = sum2ave + positionVector(1)^2;
                end
                ave2ave = sum2ave / (index2 - index1);
                aveave2 = (sumave2 / (index2 - index1)).^2;
                deltaTime = (obj.times(i, index2) - obj.times(i, index1));
                diffusion(i) = (ave2ave - aveave2) / deltaTime;
            else
                continue;
            end
        end
        obj.dcoTime(t, 1) = cc.time.point(t + 1) * 1e12;
        obj.dcoTime(t, 2) = abs(sum(diffusion) / cc.superElecs);
    end
    disp(['电子扩散系数随时间变化计算完成！耗时： ', sprintf('%.2f', toc), ' s']);
end