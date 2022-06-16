function initializeVariables(obj, cc)
    %>初始化存储变量
    obj.polar = struct('LA', {0}, 'TA', {0}, 'LO', {0}, 'TO', {0});
    obj.band = repmat(obj.polar, 1, 1);
    obj.gv = repmat(obj.polar, 1, 1);
    obj.tao = repmat(obj.polar, 1, 1);
    obj.dos = repmat(obj.polar, 1, 1);
    obj.wMin = repmat(obj.polar, 1, 1);
    obj.wMax = repmat(obj.polar, 1, 1);
    
    obj.gv.LA  = zeros(cc.NW + 2, 1);
    obj.gv.TA  = zeros(cc.NW + 2, 1);
    obj.gv.LO  = zeros(cc.NW + 2, 1);
    obj.gv.TO  = zeros(cc.NW + 2, 1);
    obj.dos.LA  = zeros(cc.NW + 2, 1);
    obj.dos.TA  = zeros(cc.NW + 2, 1);
    obj.dos.LO  = zeros(cc.NW + 2, 1);
    obj.dos.TO  = zeros(cc.NW + 2, 1);
    obj.tao.LA  = zeros(cc.NW + 2, 1);
    obj.tao.TA  = zeros(cc.NW + 2, 1);
    obj.tao.LO  = zeros(cc.NW + 2, 1);
    obj.tao.TO  = zeros(cc.NW + 2, 1);
end