function plotGeneralPropertiesHard(obj, cc)
    %>各个属性画图
    figure
    %>电子平均能量随时间变化图
    subplot(2, 2, 1)
    if ~isempty(obj.aveETime)
        slg = plot(cc.time.point(2:end-1)*1e12, obj.aveETime/cc.e);
        slg.LineWidth = 2;
    end
    xlabel("ps"); ylabel("eV");
    title("average electric energy")
    %>电子群能量分布图
    subplot(2, 2, 2)
    if ~isempty(obj.eNums)
        bar(cc.energy.point(2:end-1)/cc.e, obj.eNums);
    end
    xlabel("electron energy(eV)"); ylabel(".a.u")
    title("electron energy distribution");
    %>漂移速度随时间变化图
    subplot(2, 2, 3)
    if ~isempty(obj.driftVTime)
        slg = plot(cc.time.point(2:end-1)*1e12, obj.driftVTime*100);
        slg.LineWidth = 2;
    end
    xlabel("ps"); ylabel("cm/s");
    title("drift velocity")
    %>漂移速度随电场变化图
    subplot(2, 2, 4)
    if ~isempty(obj.driftVField)
        slg = loglog(abs(cc.eFieldInput(:, 2))*100, obj.driftVField*100, '-*');
        slg.LineWidth = 2;
    end
    xlabel("V/cm"); ylabel("cm/s");
    title("drift velocity with eField")
end