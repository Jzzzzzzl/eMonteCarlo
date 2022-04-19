function fitBandCoefficient(obj, pc)
    %>多项式拟合色散曲线
    load Si_band_GX.dat
    
    [m ,n] = size(Si_band_GX);
    obj.band = zeros(m, n + 4);
    obj.band(:, 1 : n) = deal(Si_band_GX);
    obj.band(:, 1) = linspace(0, pc.dGX, m)';
    obj.band(:, 2 : n) = obj.band(:, 2 : n)*1e12;
    
    k = obj.band(:, 1);
    %>LA
    f = obj.band(:, 2);
    obj.wMinLA = min(f);
    obj.wMaxLA = max(f);
    obj.bandLA = polyfit(k, f, 5);
    gvLAdiff = polyder(obj.bandLA);
    obj.band(:, n+1) = abs(polyval(gvLAdiff, obj.band(:, 1)));
    %>TA
    f = obj.band(:, 3);
    obj.wMinTA = min(f);
    obj.wMaxTA = max(f);
    obj.bandTA = polyfit(k, f, 5);
    gvTAdiff = polyder(obj.bandTA);
    obj.band(:, n+2) = abs(polyval(gvTAdiff, obj.band(:, 1)));
    %>LO
    f = obj.band(:, 5);
    obj.wMinLO = min(f);
    obj.wMaxLO = max(f);
    obj.bandLO = polyfit(k, f, 5);
    gvLOdiff = polyder(obj.bandLO);
    obj.band(:, n+3) = abs(polyval(gvLOdiff, obj.band(:, 1)));
    %>TO
    f = obj.band(:, 6);
    obj.wMinTO = min(f);
    obj.wMaxTO = max(f);
    obj.bandTO = polyfit(k, f, 7);
    gvTOdiff = polyder(obj.bandTO);
    obj.band(:, n+4) = abs(polyval(gvTOdiff, obj.band(:, 1)));
end