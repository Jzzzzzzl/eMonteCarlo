function initializeVariables(obj, cc)
    %>初始化声子分类统计变量
    obj.polar = struct('LA', {0}, 'TA', {0}, 'LO', {0}, 'TO', {0});
    obj.pTeff =repmat(obj.polar, cc.NW, 1);
    obj.nDot = repmat(obj.polar, cc.NW, 1);
    obj.Q = repmat(obj.polar, cc.NW, 1);
    obj.n = repmat(obj.polar, cc.NW, 1);
    for k = 1 : cc.NW
        obj.n(k).LA = ColocateField(cc);
        obj.n(k).TA = ColocateField(cc);
        obj.n(k).LO = ColocateField(cc);
        obj.n(k).TO = ColocateField(cc);
        obj.nDot(k).LA = ColocateField(cc);
        obj.nDot(k).TA = ColocateField(cc);
        obj.nDot(k).LO = ColocateField(cc);
        obj.nDot(k).TO = ColocateField(cc);
        obj.Q(k).LA = ColocateField(cc);
        obj.Q(k).TA = ColocateField(cc);
        obj.Q(k).LO = ColocateField(cc);
        obj.Q(k).TO = ColocateField(cc);
        obj.pTeff(k).LA = ColocateField(cc, cc.initTemp);
        obj.pTeff(k).TA = ColocateField(cc, cc.initTemp);
        obj.pTeff(k).LO = ColocateField(cc, cc.initTemp);
        obj.pTeff(k).TO = ColocateField(cc, cc.initTemp);
    end
end