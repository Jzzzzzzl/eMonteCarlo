function plotnAndnDot(cc)
    %>检验nDot及n的大小
    sumn = ColocateField(cc);
    for k = 1 : cc.NW
        obj.sumn.data = obj.sumn.data + obj.n(k).LA.data ...
                            + obj.n(k).TA.data + obj.n(k).LO.data + obj.n(k).TO.data;
    end
    sumnDot = ColocateField(cc);
    for k = 1 : cc.NW
        obj.sumnDot.data = obj.sumnDot.data + obj.nDot(k).LA.data ...
                            + obj.nDot(k).TA.data + obj.nDot(k).LO.data + obj.nDot(k).TO.data;
    end
    figure
    subplot(1, 2, 1)
    sumn.plotField(cc);
    title('sum_n')
    subplot(1, 2, 2)
    sumnDot.plotField(cc);
    title('sum_nDot')
    
end