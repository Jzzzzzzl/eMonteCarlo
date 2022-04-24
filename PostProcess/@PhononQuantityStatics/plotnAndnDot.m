function plotnAndnDot(obj, cc)
    %>检验nDot及n的大小
    sumn = ColocateField(cc);
    for k = 1 : cc.NW
        sumn.data = sumn.data + obj.n(k).LA.data ...
                        + obj.n(k).TA.data + obj.n(k).LO.data + obj.n(k).TO.data;
    end
    sumnDot = ColocateField(cc);
    for k = 1 : cc.NW
        sumnDot.data = sumnDot.data + obj.nDot(k).LA.data ...
                            + obj.nDot(k).TA.data + obj.nDot(k).LO.data + obj.nDot(k).TO.data;
    end
    sumQ = ColocateField(cc);
    for k = 1 : cc.NW
        sumQ.data = sumQ.data + obj.Q(k).LA.data ...
                            + obj.Q(k).TA.data + obj.Q(k).LO.data + obj.Q(k).TO.data;
    end
    sumn.plotField(cc);
    sumnDot.plotField(cc);
    sumQ.plotField(cc);
end