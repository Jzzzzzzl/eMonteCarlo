function initializeVariables(obj, cc)
    %>
    obj.taoLA = zeros(cc.NW + 2, 1);
    obj.taoTA = zeros(cc.NW + 2, 1);
    obj.taoLO = zeros(cc.NW + 2, 1);
    obj.taoTO = zeros(cc.NW + 2, 1);
    obj.dosLA = zeros(cc.NW + 2, 1);
    obj.dosTA = zeros(cc.NW + 2, 1);
    obj.dosLO = zeros(cc.NW + 2, 1);
    obj.dosTO = zeros(cc.NW + 2, 1);
    obj.gvLA  = zeros(cc.NW + 2, 1);
    obj.gvTA  = zeros(cc.NW + 2, 1);
    obj.gvLO  = zeros(cc.NW + 2, 1);
    obj.gvTO  = zeros(cc.NW + 2, 1);
end