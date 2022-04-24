function initializeVariables(obj, cc)
    %>初始化存储变量
    obj.taoLA = zeros(cc.NW + 2, 1);
    obj.taoLO = zeros(cc.NW + 2, 1);
    obj.dosLA = zeros(cc.NW + 2, 1);
    obj.dosLO = zeros(cc.NW + 2, 1);
    obj.gvLA  = zeros(cc.NW + 2, 1);
    obj.gvLO  = zeros(cc.NW + 2, 1);
end