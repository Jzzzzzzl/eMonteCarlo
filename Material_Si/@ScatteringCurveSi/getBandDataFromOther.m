function getBandDataFromOther(obj, cc)
    %>
    load wvDt.mat
    deltaw = w(2) - w(1);
    minW = w(1) - deltaw/2;
    maxW = w(end) + deltaw/2;
    cc.frequencyGrid(minW, maxW, length(w));
    cc.frequency.face(1) = 0;
    cc.frequency.point(1) = 0;
    obj.gvLA(2:end-1)  = vsi(:, 3);
    obj.gvTA(2:end-1)  = vsi(:, 1);
    obj.gvLO(2:end-1)  = vsi(:, 4);
    obj.gvTO(2:end-1)  = vsi(:, 5);
    obj.dosLA(2:end-1) = Dsi(:, 3);
    obj.dosLA(2) = obj.dosLA(3);
    obj.dosTA(2:end-1) = Dsi(:, 1);
    obj.dosTA(2) = obj.dosTA(3);
    obj.dosLO(2:end-1) = Dsi(:, 4);
    
    obj.dosTO(2:end-1) = Dsi(:, 5);
    obj.taoLA(2:end-1) = tsi(:, 3);
    obj.taoTA(2:end-1) = tsi(:, 1);
    obj.taoLO(2:end-1) = tsi(:, 4);
    obj.taoTO(2:end-1) = tsi(:, 5);
end