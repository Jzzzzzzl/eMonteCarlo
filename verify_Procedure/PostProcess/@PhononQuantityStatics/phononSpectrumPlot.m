function [wNumab] = phononSpectrumPlot(obj, mm, pc, type)
    %>声子谱画图
    wNumab = zeros(obj.NW, 2);
    wNumem = zeros(obj.NW, 2);
    mm.frequencyGrid(obj.minFrequency, obj.maxFrequency, obj.NW);
    switch type
        case "LA"
            tempab = obj.phLAab;
            tempem = obj.phLAem;
        case "TA"
            tempab = obj.phTAab;
            tempem = obj.phTAem;
        case "LO"
            tempab = obj.phLOab;
            tempem = obj.phLOem;
        case "TO"
            tempab = obj.phTOab;
            tempem = obj.phTOem;
        case "ALL"
            tempab = obj.phALLab;
            tempem = obj.phALLem;
    end

    for k = 1 : obj.NW
        wNumab(k, 1) = tempab(k).num;
        wNumab(k, 2) = pc.hbar * mm.frequency.point(k + 1) / pc.e * 1000;
        wNumem(k, 1) = tempem(k).num;
        wNumem(k, 2) = pc.hbar * mm.frequency.point(k + 1) / pc.e * 1000;
    end
    figure
    slg = plot(wNumab(:, 1), wNumab(:, 2));
    slg.LineWidth = 2;
    hold on
    slg = plot(wNumem(:, 1), wNumem(:, 2));
    slg.LineWidth = 2;
    xlabel(".a.u");ylabel("meV");
    legend("phonon absorb numbers", "phonon emission numbers")
end