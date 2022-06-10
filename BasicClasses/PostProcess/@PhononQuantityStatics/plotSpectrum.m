function plotSpectrum(obj, pc, cc, type, region)
    %>声子谱画图
    if region(1)*region(3) == 0
        error("起始点不要设为0！")
    end
    region = region * 1e-9;
    ixl = find(cc.modelx.face >= region(1), 1) - 1;
    ixr = find(cc.modelx.face >= region(2), 1) - 1;
    iyb = find(cc.modely.face >= region(3), 1) - 1;
    iyt = find(cc.modely.face >= region(4), 1) - 1;
    
    wNumab = zeros(cc.NW, 2);
    wNumem = zeros(cc.NW, 2);
    switch type
        case "LA"
            tempab = obj.allSumN(ixl:ixr, iyb:iyt, :, 1, 1);
            tempem = obj.allSumN(ixl:ixr, iyb:iyt, :, 1, 2);
        case "TA"
            tempab = obj.allSumN(ixl:ixr, iyb:iyt, :, 2, 1);
            tempem = obj.allSumN(ixl:ixr, iyb:iyt, :, 2, 2);
        case "LO"
            tempab = obj.allSumN(ixl:ixr, iyb:iyt, :, 3, 1);
            tempem = obj.allSumN(ixl:ixr, iyb:iyt, :, 3, 2);
        case "TO"
            tempab = obj.allSumN(ixl:ixr, iyb:iyt, :, 4, 1);
            tempem = obj.allSumN(ixl:ixr, iyb:iyt, :, 4, 2);
        case "ALL"
            tempab = obj.allSumN(ixl:ixr, iyb:iyt, :, 1, 1) + obj.allSumN(ixl:ixr, iyb:iyt, :, 2, 1) ...
                         + obj.allSumN(ixl:ixr, iyb:iyt, :, 3, 1) + obj.allSumN(ixl:ixr, iyb:iyt, :, 4, 1);
            tempem = obj.allSumN(ixl:ixr, iyb:iyt, :, 1, 2) + obj.allSumN(ixl:ixr, iyb:iyt, :, 2, 2) ...
                         + obj.allSumN(ixl:ixr, iyb:iyt, :, 3, 2) + obj.allSumN(ixl:ixr, iyb:iyt, :, 4, 2);
    end

    for k = 1 : cc.NW
        wNumab(k, 1) = sum(tempab(:, :, k));
        wNumab(k, 2) = pc.hbar * cc.frequency.point(k + 1) / pc.e * 1000;
        wNumem(k, 1) = sum(tempem(:, :, k));
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