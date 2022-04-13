function convectionOperator(eqn, mm, massflux, phi)
    %>
    %>循环内部x面
    for i = 2 : mm.NX
        for j = 1 : mm.NY
            deltay = mm.modely.face(j+1) - mm.modely.face(j);
            mf = massflux.datax(i, j+1) * deltay;
            leftCellID = getGlobalID(mm.NX, mm.NY, i - 1, j);
            rightCellID = getGlobalID(mm.NX, mm.NY, i, j);
            if mf >= 0
                eqn.addToMatrix(leftCellID, leftCellID, abs(mf));
                eqn.addToMatrix(rightCellID, leftCellID, -abs(mf));
            else
                eqn.addToMatrix(leftCellID, rightCellID, -abs(mf));
                eqn.addToMatrix(rightCellID, rightCellID, abs(mf));
            end
        end
    end
    %>循环内部y面
    for i = 1 : mm.NX
        deltax = mm.modelx.face(i+1) - mm.modelx.face(i);
        for j = 2 : mm.NY
            mf = massflux.datay(i+1, j) * deltax;
            bottomCellID = getGlobalID(mm.NX, mm.NY, i, j - 1);
            topCellID = getGlobalID(mm.NX, mm.NY, i, j);
            if mf >= 0
                eqn.addToMatrix(bottomCellID, bottomCellID, abs(mf));
                eqn.addToMatrix(topCellID, bottomCellID, -abs(mf));
            else
                eqn.addToMatrix(bottomCellID, topCellID, -abs(mf));
                eqn.addToMatrix(topCellID, topCellID, abs(mf));
            end
        end
    end
    %>循环上下边界面
    for i = 1 : mm.NX
        deltax = mm.modelx.face(i+1) - mm.modelx.face(i);
        bottomMf = massflux.datay(i+1, 1) * deltax;
        %>下边界
        if bottomMf >= 0
            c1 = phi.bottom(i+1, 1);
            c2 = phi.bottom(i+1, 2);
            globalID = getGlobalID(mm.NX, mm.NY, i, 1);
            eqn.addToMatrix(globalID, globalID, abs(c1 * bottomMf));
            eqn.addToRHS(globalID, abs(c2 * bottomMf));
        else
            globalID = getGlobalID(mm.NX, mm.NY, i, 1);
            eqn.addToMatrix(globalID, globalID, abs(bottomMf));
        end
        %>上边界
        topMf = massflux.datay(i+1, mm.NY+1) * deltax;
        if topMf >= 0
            globalID = getGlobalID(mm.NX, mm.NY, i, mm.NY);
            eqn.addToMatrix(globalID, globalID, abs(topMf));
        else
            c1 = phi.top(i+1, 1);
            c2 = phi.top(i+1, 2);
            globalID = getGlobalID(mm.NX, mm.NY, i, mm.NY);
            eqn.addToMatrix(globalID, globalID, abs(c1 * topMf));
            eqn.addToRHS(globalID, abs(c2 * topMf));
        end
    end
    %>循环左右边界面
    for j = 1 : mm.NY
        deltay = mm.modely.face(j+1) - mm.modely.face(j);
        leftMf = massflux.datax(1, j+1) * deltay;
        %>左边界
        if leftMf >= 0
            c1 = phi.left(j+1, 1);
            c2 = phi.left(j+1, 2);
            globalID = getGlobalID(mm.NX, mm.NY, 1, j);
            eqn.addToMatrix(globalID, globalID, abs(c1 * leftMf));
            eqn.addToRHS(globalID, abs(c2 * leftMf));
        else
            globalID = getGlobalID(mm.NX, mm.NY, 1, j);
            eqn.addToMatrix(globalID, globalID, abs(leftMf));
        end
        %>右边界
        rightMf = massflux.datax(mm.NX+1, j+1) * deltay;
        if rightMf >= 0
            globalID = getGlobalID(mm.NX, mm.NY, mm.NX, j);
            eqn.addToMatrix(globalID, globalID, abs(rightMf));
        else
            c1 = phi.right(j+1, 1);
            c2 = phi.right(j+1, 2);
            globalID = getGlobalID(mm.NX, mm.NY, mm.NX, j);
            eqn.addToMatrix(globalID, globalID, abs(c1 * rightMf));
            eqn.addToRHS(globalID, abs(c2 * rightMf));
        end
    end
end