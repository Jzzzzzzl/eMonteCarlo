function computeMobilityWithTime(obj, cc)
    %>计算迁移率随时间变化
    tic
    [n, ~] = size(obj.dcoTime);
    obj.mobTime = zeros(n, 2);
    for t = 1 : n
        obj.mobTime(t, 1) = obj.dcoTime(t, 1);
        obj.mobTime(t, 2) = obj.e*obj.dcoTime(t, 2) ...
                        / (obj.kb*cc.initTemp*(1 + 0.35355*cc.initDopDen/(2.18e21*cc.initTemp^(3/2))));
    end
    disp(['迁移率随时间变化计算完成！耗时： ', sprintf('%.2f', toc), ' s']);
end