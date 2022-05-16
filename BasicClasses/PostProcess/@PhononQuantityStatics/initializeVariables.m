function initializeVariables(obj, cc)
    %>初始化声子分类统计变量
    basisStatics = struct("pop", {0}, "num", {0});
    obj.phLAab = repmat(basisStatics, cc.NW, 1);
    obj.phLAem = repmat(basisStatics, cc.NW, 1);
    obj.phTAab = repmat(basisStatics, cc.NW, 1);
    obj.phTAem = repmat(basisStatics, cc.NW, 1);
    obj.phLOab = repmat(basisStatics, cc.NW, 1);
    obj.phLOem = repmat(basisStatics, cc.NW, 1);
    obj.phTOab = repmat(basisStatics, cc.NW, 1);
    obj.phTOem = repmat(basisStatics, cc.NW, 1);
    obj.phALLab = repmat(basisStatics, cc.NW, 1);
    obj.phALLem = repmat(basisStatics, cc.NW, 1);
    obj.phPosition = repmat(basisStatics, cc.NX*cc.NY, 1);
    
    polar = struct('LA', {0}, 'TA', {0}, 'LO', {0}, 'TO', {0});
    obj.pTeff =repmat(polar, cc.NW, 1);
    obj.nDot = repmat(polar, cc.NW, 1);
    obj.Q = repmat(polar, cc.NW, 1);
    obj.n = repmat(polar, cc.NW, 1);
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
        obj.pTeff(k).LA = ColocateField(cc, cc.envTemp);
        obj.pTeff(k).TA = ColocateField(cc, cc.envTemp);
        obj.pTeff(k).LO = ColocateField(cc, cc.envTemp);
        obj.pTeff(k).TO = ColocateField(cc, cc.envTemp);
    end
end