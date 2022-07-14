function computeDirftVelocityWithTimeSoft(obj, cc)
    %>计算漂移速度随时间变化
    tic
    velocitys = zeros(cc.Nt, 1);
    for t = 1 : cc.Nt
        velocitys(t) = sum(obj.driftVTime(t, :)) / sum(obj.driftVTime(t, :) ~= 0);
    end
    obj.driftVTime = velocitys;
    disp(['漂移速度随时间变化计算完成！耗时：', sprintf('%.2f', toc), ' s'])
end