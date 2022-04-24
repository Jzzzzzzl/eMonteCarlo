function initializeDataValue(obj, mm, initiaValue)
    %>按给定初始值进行初始化
    for i = 1 : mm.NX+2
        for j = 1 : mm.NY+2
            obj.data(i, j) = initiaValue;
        end
    end
end