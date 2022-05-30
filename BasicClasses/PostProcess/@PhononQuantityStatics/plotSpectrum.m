function plotSpectrum(obj, pc, cc, type)
    %>声子谱画图
    wNumab = zeros(cc.NW, 2);
    wNumem = zeros(cc.NW, 2);
    switch type
        case "LA"
            tempab = obj.allSumN(:, 1, 1);
            tempem = obj.allSumN(:, 1, 2);
        case "TA"
            tempab = obj.allSumN(:, 2, 1);
            tempem = obj.allSumN(:, 2, 2);
        case "LO"
            tempab = obj.allSumN(:, 3, 1);
            tempem = obj.allSumN(:, 3, 2);
        case "TO"
            tempab = obj.allSumN(:, 4, 1);
            tempem = obj.allSumN(:, 4, 2);
        case "ALL"
            tempab = obj.allSumN(:, 1, 1) + obj.allSumN(:, 2, 1) + obj.allSumN(:, 3, 1) + obj.allSumN(:, 4, 1);
            tempem = obj.allSumN(:, 1, 2) + obj.allSumN(:, 2, 2) + obj.allSumN(:, 3, 2) + obj.allSumN(:, 4, 2);
    end

    for k = 1 : cc.NW
        wNumab(k, 1) = tempab(k);
        wNumab(k, 2) = pc.hbar * cc.frequency.point(k + 1) / pc.e * 1000;
        wNumem(k, 1) = tempem(k);
        wNumem(k, 2) = pc.hbar * cc.frequency.point(k + 1) / pc.e * 1000;
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