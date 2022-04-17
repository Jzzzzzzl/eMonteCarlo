function setInitialGuess(obj, mm, phi)
    %>将正交网格中的数值添加到CSR顺序表中
    for i = 1 : mm.NX
        for j = 1 : mm.NY
            globalID = getGlobalID(mm.NX, mm.NY, i, j);
            obj.result(globalID) = phi.data(i+1, j+1);
        end
    end
end