function electronDiffusionCoefficient(obj, sh, cc)
    %>计算扩散系数
    diffusion = zeros(cc.superElecs, 1);
    for i = 1 : cc.superElecs
        sum2ave = 0;
        sumave2 = 0;
        times = [sh.eHistory(i, :).time];
        index = find(obj.minimumTime <= times, 1);
        for j = 1 : index
            positionVector = sh.eHistory(i, j).position;
            sumave2 = sumave2 + positionVector(1);
            sum2ave = sum2ave + positionVector(1)^2;
        end
        ave2ave = sum2ave / (index);
        aveave2 = (sumave2 / (index)).^2;
        diffusion(i) = (ave2ave - aveave2) / obj.minimumTime;
    end
    obj.diffusionCoe = abs(sum(diffusion) / cc.superElecs);
    disp(['电子扩散系数为： ', num2str(obj.diffusionCoe * 1e4), '  cm^2/s']);
end