function computeValleyOccupationWithTime(obj, cc)
    %>能谷占据率随时间变化图
    tic
    occupys = zeros(cc.Nt, 3);
    for t = 1 : cc.Nt
        occupys(t, :) = obj.occTime(t, :) / sum(obj.occTime(t, :));
    end
    obj.occTime = occupys;
    disp(['能谷占据率随时间变化计算完成！耗时：', sprintf('%.2f', toc), ' s'])
    figure
    hold on
    [~, n] = size(obj.occTime);
    for i = 1 : n
        slg = plot(cc.time.point(2:end-1)*1e12, obj.occTime(:, i));
        slg.LineWidth = 2;
    end
    xlabel("ps"); ylabel(".a.u");
    legend('U', 'Gamma1', 'Gamma3')
    title("valley occupation")
    hold off
    %>写入文件
    writeDataToFile1D('occTime', cc, cc.time.point(2:end-1)*1e12, occupys);
end