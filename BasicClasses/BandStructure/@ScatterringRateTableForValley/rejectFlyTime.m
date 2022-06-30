function rejectFlyTime(obj, cc, es)
    %>拒绝算法生成飞行时间
    a = es.position(1) - cc.regionPB(1);
    b = cc.regionCH(2) - es.position(1);
    if a*b <= 0
        obj.computeFlyTime(es);
    elseif cc.dtConst ~= 0
        obj.flyTime = cc.dtConst;
    else
        obj.computeFlyTime(es);
    end
end