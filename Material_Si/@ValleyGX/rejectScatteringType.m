function rejectScatteringType(obj, cc, es)
    %>散射类型的拒绝算法
    a = es.position(1) - cc.regionPB(1);
    b = cc.regionPB(2) - es.position(1);
    if a*b > 0
        bool = true;
        while bool
            obj.computeScatType(cc, es);
            if obj.scatType <= 11 && obj.scatType ~= 9
                bool = false;
            end
        end
    else
        obj.computeScatType(cc, es);
    end
end