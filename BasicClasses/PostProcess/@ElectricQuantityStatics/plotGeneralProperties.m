function plotGeneralProperties(obj)
    %>各个属性画图
    figure
    %>电子平均能量随时间变化图
    subplot(4, 2, 1)
    slg = plot(obj.aveEtime(:, 1), obj.aveEtime(:, 2));
    slg.LineWidth = 2;
    xlabel("ps"); ylabel("eV");
    title("average electric energy")
    %>电子群能量分布图
    subplot(4, 2, 2)
    bar(obj.enumbers(:, 1), obj.enumbers(:, 2));
    xlabel("electron energy(eV)"); ylabel(".a.u")
    title("electron energy distribution");
    %>漂移速度随时间变化图
    subplot(4, 2, 3)
    slg = plot(obj.driftVtime(:, 1), obj.driftVtime(:, 2)*100);
%     slg = loglog(obj.driftVtime(:, 1), obj.driftVtime(:, 2)*100);
    slg.LineWidth = 2;
    xlabel("ps"); ylabel("cm/s");
    title("drift velocity")
    %>电子波矢分布画图
    subplot(4, 2, 4)
    hold on
    n = size(obj.qnumbers);
    for i = 2 : n(2)
        slg = plot(obj.qnumbers(:, 1), obj.qnumbers(:, i));
        slg.LineWidth = 2;
    end
    xlabel("k/1/m"); ylabel(".a.u");
    legend(sprintfc('%g', linspace(1, n(2) - 1, n(2) - 1)))
    title("qvector distribution")
    hold off
    %>漂移速度随电场变化图
    subplot(4, 2, 5)
    slg = loglog(obj.driftVfield(:, 1), obj.driftVfield(:, 2)*100, '-*');
%     slg = plot(obj.driftVfield(:, 1), obj.driftVfield(:, 2)*100, '-*');
    slg.LineWidth = 2;
    xlabel("V/m"); ylabel("cm/s");
    title("drift velocity with eField")
    %>扩散系数随电场变化图
    subplot(4, 2, 6)
    slg = plot(obj.diffusionField(:, 1), obj.diffusionField(:, 2)*1e4, '-*');
    slg.LineWidth = 2;
    xlabel("V/m"); ylabel("cm^2/(V*s)");
    title("diffusion coefficient with eField")
    %>迁移率随电场变化图
    subplot(4, 2, 7)
    slg = plot(obj.mobilityField(:, 1), obj.mobilityField(:, 2)*1e4, '-*');
    slg.LineWidth = 2;
    xlabel("V/m"); ylabel("cm^2/(V*s)");
    title("diffusion coefficient with eField")
end