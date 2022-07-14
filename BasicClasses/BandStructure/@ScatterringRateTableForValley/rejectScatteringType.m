function rejectScatteringType(obj, cc, es)
    %>散射类型的拒绝算法，包括势垒区和非热点区
    %>非热点区散射概率
    index = find(cc.modelx.face >= es.position(1), 1);
    z = randNumber(0, 1);
    Z = normpdf(z, 1, 1*1/sqrt(2*pi));
    if Z <= cc.scatProba(index)
        %>势垒区散射类型选取
        a = es.position(1) - cc.regionPB(1);
        b = cc.regionPB(2) - es.position(1);
        index = find(cc.energyPB(:, 1) >= es.position(1), 1);
        if a*b > 0 && es.energy < cc.energyPB(index, 2)
            bool = true;
            maxitem = 0;
            while bool && maxitem < 20
                obj.computeScatType(cc, es);
                if sum(cc.scatypePB == es.scatype) == 1
                    bool = false;
                end
                maxitem = maxitem + 1;
            end
        else
            obj.computeScatType(cc, es);
        end
    else
        es.scatype = 1;
        es.theta = randNumber(0, pi);
    end
end