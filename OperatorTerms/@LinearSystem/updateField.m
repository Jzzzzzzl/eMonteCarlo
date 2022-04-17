function updateField(obj, mm, phi)
    %>将计算结果更新到物理场
    for i = 1 : mm.NX
        for j = 1 : mm.NY
            globalID = getGlobalID(mm.NX, mm.NY, i, j);
            phi.data(i+1, j+1) = obj.result(globalID);
        end
    end
end