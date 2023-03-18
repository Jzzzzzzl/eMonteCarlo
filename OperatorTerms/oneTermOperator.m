function oneTermOperator(eqn, mm, sp)
    %>一阶函数离散算子
    for i = 1 : mm.NX
        for j = 1 : mm.NY
            deltax = mm.modelx.face(i+1) - mm.modelx.face(i);
            deltay = mm.modely.face(j+1) - mm.modely.face(j);
            deltav = deltax * deltay;
            oneTermCoe_ap = sp.data(i+1, j+1) * deltav;
            globalID = getGlobalID(mm.NX, mm.NY, i, j);
            eqn.addToMatrix(globalID, globalID, -oneTermCoe_ap);
        end
    end
end