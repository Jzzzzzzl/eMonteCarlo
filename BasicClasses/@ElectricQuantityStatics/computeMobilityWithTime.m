function computeMobilityWithTime(obj, cc, pc)
    %>计算迁移率随时间变化图
    tic
    [n, ~] = size(obj.diffusionCoe);
    dop = max(max(cc.dopDensity.data));
    obj.mobilityTime = zeros(n, 2);
    for t = 1 : n
        obj.mobilityTime(t, 1) = obj.diffusionCoe(t, 1);
        obj.mobilityTime(t, 2) = obj.e*obj.diffusionCoe(t, 2) ...
                        / (pc.kb*cc.envTemp*(1 + 0.35355*dop/(2.18e21*cc.envTemp^(3/2))));
    end
    disp(['迁移率随时间变化计算完成！耗时： ', sprintf('%.2f', toc), ' s']);
end