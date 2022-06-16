function fitBandCoefficient(obj, pc)
    %>多项式拟合色散曲线
    load GaN_band_GL.dat
    
    [m ,n] = size(GaN_band_GL);
    obj.qband = zeros(m, n + 2);
    obj.qband(:, 1 : n) = deal(GaN_band_GL);
    obj.qband(:, 1) = linspace(0, pc.dGL, m)';
    obj.qband(:, 2 : n) = obj.qband(:, 2 : n)*2*pi*1e12;
    
    k = obj.qband(:, 1);
    %>LA
    f = obj.qband(:, 2);
    obj.wMin.LA = min(f);
    obj.wMax.LA = max(f);
    obj.band.LA = polyfit(k, f, 5);
    gvLAdiff = polyder(obj.band.LA);
    obj.qband(:, n+1) = abs(polyval(gvLAdiff, obj.qband(:, 1)));
    %>LO
    f = obj.qband(:, 12);
    obj.wMin.LO = min(f);
    obj.wMax.LO = max(f);
    obj.band.LO = polyfit(k, f, 7);
    gvLOdiff = polyder(obj.band.LO);
    obj.qband(:, n+2) = abs(polyval(gvLOdiff, obj.qband(:, 1)));
end