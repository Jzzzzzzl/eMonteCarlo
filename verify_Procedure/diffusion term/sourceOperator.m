function sourceOperator(eqn, mm, sc)
    %>
    for i = 1 : mm.NX
        for j = 1 : mm.NY
            deltax = mm.modelx.face(i+1) - mm.modelx.face(i);
            deltay = mm.modely.face(j+1) - mm.modely.face(j);
            deltav = deltax * deltay;
            globalID = getGlobalID(mm.NX, mm.NY, i, j);
            eqn.addToRHS(globalID, sc.data(i+1, j+1) * deltav);
        end
    end
end