function fitBandCoefficient(obj, pc)
    %>多项式拟合色散曲线
    load Si_band_GX.dat
    
    [m ,n] = size(Si_band_GX);
    obj.qband = zeros(m, n + 4);
    obj.qband(:, 1 : n) = deal(Si_band_GX);
    obj.qband(:, 1) = linspace(0, pc.dGX, m)';
    obj.qband(:, 2 : n) = obj.qband(:, 2 : n)*2*pi*1e12;
    
    k = obj.qband(:, 1);
    %>LA
    f = obj.qband(:, 2);
    obj.wMin.LA = min(f);
    obj.wMax.LA = max(f);
    obj.band.LA = polyfit(k, f, 5);
    gvLAdiff = polyder(obj.band.LA);
    obj.qband(:, n+1) = abs(polyval(gvLAdiff, obj.qband(:, 1)));
    %>TA
    f = obj.qband(:, 3);
    obj.wMin.TA = min(f);
    obj.wMax.TA = max(f);
    obj.band.TA = polyfit(k, f, 5);
    gvTAdiff = polyder(obj.band.TA);
    obj.qband(:, n+2) = abs(polyval(gvTAdiff, obj.qband(:, 1)));
    %>LO
    f = obj.qband(:, 5);
    obj.wMin.LO = min(f);
    obj.wMax.LO = max(f);
    obj.band.LO = polyfit(k, f, 5);
    gvLOdiff = polyder(obj.band.LO);
    obj.qband(:, n+3) = abs(polyval(gvLOdiff, obj.qband(:, 1)));
    %>TO
    f = obj.qband(:, 6);
    obj.wMin.TO = min(f);
    obj.wMax.TO = max(f);
    obj.band.TO = polyfit(k, f, 7);
    gvTOdiff = polyder(obj.band.TO);
    obj.qband(:, n+4) = abs(polyval(gvTOdiff, obj.qband(:, 1)));
end