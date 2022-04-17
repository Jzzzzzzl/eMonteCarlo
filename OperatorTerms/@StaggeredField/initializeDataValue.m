function initializeDataValue(obj, mm, initiaValue1, initiaValue2)
    %>按给定初始值进行初始化
    for i = 1 : mm.NX + 1
        for j = 1 : mm.NY + 2
            obj.datax(i, j) = initiaValue1;
        end
    end
    for i = 1 : mm.NX + 2
        for j = 1 : mm.NY + 1
            obj.datay(i, j) = initiaValue2;
        end
    end
end