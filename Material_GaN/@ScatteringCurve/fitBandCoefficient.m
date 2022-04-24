function fitBandCoefficient(obj, pc)
    %>多项式拟合色散曲线
    load GaN_band_GL.dat
    
    [m ,n] = size(GaN_band_GL);
    obj.band = zeros(m, n + 2);
    obj.band(:, 1 : n) = deal(GaN_band_GL);
    obj.band(:, 1) = linspace(0, pc.dGL, m)';
    obj.band(:, 2 : n) = obj.band(:, 2 : n)*2*pi*1e12;
    
    k = obj.band(:, 1);
    %>LA
    f = obj.band(:, 2);
    obj.wMinLA = min(f);
    obj.wMaxLA = max(f);
    obj.bandLA = polyfit(k, f, 5);
    gvLAdiff = polyder(obj.bandLA);
    obj.band(:, n+1) = abs(polyval(gvLAdiff, obj.band(:, 1)));
    %>LO
    f = obj.band(:, 12);
    obj.wMinLO = min(f);
    obj.wMaxLO = max(f);
    obj.bandLO = polyfit(k, f, 7);
    gvLOdiff = polyder(obj.bandLO);
    obj.band(:, n+2) = abs(polyval(gvLOdiff, obj.band(:, 1)));
end