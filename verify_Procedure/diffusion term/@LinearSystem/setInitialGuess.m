function setInitialGuess(obj, mm, phi)
    %>
    for i = 1 : mm.NX
        for j = 1 : mm.NY
            globalID = getGlobalID(mm.NX, mm.NY, i, j);
            obj.result(globalID) = phi.data(i+1, j+1);
        end
    end
end