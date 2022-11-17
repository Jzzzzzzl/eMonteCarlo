function getBandDataFromOther(obj, cc)
    %>从shengBTE获得群速度/态密度/弛豫时间
    load wvDt.mat
    deltaw = w(2) - w(1);
    minW = w(1) - deltaw/2;
    maxW = w(end) + deltaw/2;
    cc.frequencyGrid(minW, maxW, length(w));
    cc.frequency.face(1) = 0;
    cc.frequency.point(1) = 0;
    
    obj.gv.LA(2:end-1)  = vsi(:, 3);
    obj.gv.TA(2:end-1)  = vsi(:, 1);
    obj.gv.LO(2:end-1)  = vsi(:, 10) + vsi(:, 11) + vsi(:, 12);
    obj.gv.TO(2:end-1)  = vsi(:, 10) + vsi(:, 11) + vsi(:, 12);
    
    obj.dos.LA(2:end-1) = Dsi(:, 3);
    obj.dos.LA(2) = obj.dos.LA(3)/2;
    obj.dos.TA(2:end-1) = Dsi(:, 1);
    obj.dos.TA(2) = obj.dos.TA(3)/2;
    obj.dos.LO(2:end-1) = Dsi(:, 10) + Dsi(:, 11) + Dsi(:, 12);
    obj.dos.TO(2:end-1) = Dsi(:, 10) + Dsi(:, 11) + Dsi(:, 12);
    
    obj.tao.LA(2:end-1) = tsi(:, 3);
    obj.tao.TA(2:end-1) = tsi(:, 1);
    obj.tao.LO(2:end-1) = tsi(:, 10) + tsi(:, 11) + tsi(:, 12);
    obj.tao.TO(2:end-1) = tsi(:, 10) + tsi(:, 11) + tsi(:, 12);
end