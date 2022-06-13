function plotGeneralProperties(obj)
    %>各个属性画图
    figure
    %>电子平均能量随时间变化图
    subplot(4, 2, 1)
    slg = plot(obj.aveETime(:, 1), obj.aveETime(:, 2));
    slg.LineWidth = 2;
    xlabel("ps"); ylabel("eV");
    title("average electric energy")
    %>电子群能量分布图
    subplot(4, 2, 2)
    bar(obj.eNums(:, 1), obj.eNums(:, 2));
    xlabel("electron energy(eV)"); ylabel(".a.u")
    title("electron energy distribution");
    %>漂移速度随时间变化图
    subplot(4, 2, 3)
    slg = plot(obj.driftVTime(:, 1), obj.driftVTime(:, 2)*100);
%     slg = loglog(obj.driftVTime(:, 1), obj.driftVTime(:, 2)*100);
    slg.LineWidth = 2;
    xlabel("ps"); ylabel("cm/s");
    title("drift velocity")
    %>电子波矢分布画图
    subplot(4, 2, 4)
    hold on
    n = size(obj.qNums);
    for i = 2 : n(2)
        slg = plot(obj.qNums(:, 1), obj.qNums(:, i));
        slg.LineWidth = 2;
    end
    xlabel("k/1/m"); ylabel(".a.u");
    legend(sprintfc('%g', linspace(1, n(2) - 1, n(2) - 1)))
    title("qvector distribution")
    hold off
    %>漂移速度随电场变化图
    subplot(4, 2, 5)
%     slg = loglog(obj.driftVField(:, 1), obj.driftVField(:, 2)*100, '-*');
    slg = plot(obj.driftVField(:, 1), obj.driftVField(:, 2)*100, '-*');
    slg.LineWidth = 2;
    xlabel("V/m"); ylabel("cm/s");
    title("drift velocity with eField")
    %>扩散系数随电场变化图
    subplot(4, 2, 6)
    slg = plot(obj.dcoField(:, 1), obj.dcoField(:, 2)*1e4, '-*');
    slg.LineWidth = 2;
    xlabel("V/m"); ylabel("cm^2/(V*s)");
    title("diffusion coefficient with eField")
    %>迁移率随电场变化图
    subplot(4, 2, 7)
    slg = plot(obj.mobField(:, 1), obj.mobField(:, 2)*1e4, '-*');
    slg.LineWidth = 2;
    xlabel("V/m"); ylabel("cm^2/(V*s)");
    title("diffusion coefficient with eField")
end