function diffusionOperator(eqn, mm, lambda, phi)
    %>扩散项离散算子
    %>循环内部x面
    for i = 2 : mm.NX 
        dx_left = mm.modelx.face(i) - mm.modelx.point(i);
        dx_right = mm.modelx.point(i+1) - mm.modelx.face(i);
        dx = dx_left + dx_right;
        for j = 1 : mm.NY
            deltaY = mm.modely.face(j+1) - mm.modely.face(j);
            diffCoefficient = lambda.datax(i, j+1)*deltaY / dx;
            leftCellID = getGlobalID(mm.NX, mm.NY, i - 1, j);
            rightCellID = getGlobalID(mm.NX, mm.NY, i, j);
            eqn.addToMatrix(leftCellID, leftCellID, diffCoefficient);
            eqn.addToMatrix(leftCellID, rightCellID, -diffCoefficient);
            eqn.addToMatrix(rightCellID, rightCellID, diffCoefficient);
            eqn.addToMatrix(rightCellID, leftCellID, -diffCoefficient);
        end
    end
    %>循环内部y面
    for i = 1 : mm.NX
        deltaX = mm.modelx.face(i+1) - mm.modelx.face(i);
        for j = 2 : mm.NY
            dy_top = mm.modely.point(j+1) - mm.modely.face(j);
            dy_bottom = mm.modely.face(j) - mm.modely.point(j);
            dy = dy_top +  dy_bottom;
            diffCoefficient = lambda.datay(i+1, j)*deltaX / dy;
            bottomCellID = getGlobalID(mm.NX, mm.NY, i, j - 1);
            topCellID = getGlobalID(mm.NX, mm.NY, i, j);
            eqn.addToMatrix(bottomCellID, bottomCellID, diffCoefficient);
            eqn.addToMatrix(bottomCellID, topCellID, -diffCoefficient);
            eqn.addToMatrix(topCellID, topCellID, diffCoefficient);
            eqn.addToMatrix(topCellID, bottomCellID, -diffCoefficient);
        end
    end
    %>循环上下边界面
    dbottom = mm.modely.point(2) - mm.modely.face(1);
    dtop = mm.modely.face(mm.NY+1) - mm.modely.point(mm.NY+1);
    for i = 1 : mm.NX
        deltaX = mm.modelx.face(i+1) - mm.modelx.face(i);
        diffCoefficient = lambda.datay(i+1, 1)*deltaX / dbottom;
        globalID = getGlobalID(mm.NX, mm.NY, i, 1);
        c1 = phi.bottom(i+1, 1);
        c2 = phi.bottom(i+1, 2);
        eqn.addToMatrix(globalID, globalID, diffCoefficient*(1 - c1));
        eqn.addToRHS(globalID, diffCoefficient*c2);
        
        diffCoefficient = lambda.datay(i+1, mm.NY+1)*deltaX / dtop;
        globalID = getGlobalID(mm.NX, mm.NY, i, mm.NY);
        c1 = phi.top(i+1, 1);
        c2 = phi.top(i+1, 2);
        eqn.addToMatrix(globalID, globalID, diffCoefficient*(1 - c1));
        eqn.addToRHS(globalID, diffCoefficient*c2);
    end
    %>循环左右边界面
    dright = mm.modelx.face(mm.NX+1) - mm.modelx.point(mm.NX+1);
    dleft = mm.modelx.point(2) - mm.modelx.face(1);
    for j = 1 : mm.NY
        deltaY = mm.modely.face(j+1) - mm.modely.face(j);
        diffCoefficient = lambda.datax(1, j+1)*deltaY / dleft;
        globalID = getGlobalID(mm.NX, mm.NY, 1, j);
        c1 = phi.left(j+1, 1);
        c2 = phi.left(j+1, 2);
        eqn.addToMatrix(globalID, globalID, diffCoefficient*(1 - c1));
        eqn.addToRHS(globalID, diffCoefficient*c2);
        
        diffCoefficient = lambda.datax(mm.NX+1, j+1)*deltaY / dright;
        globalID = getGlobalID(mm.NX, mm.NY, mm.NX, j);
        c1 = phi.right(j+1, 1);
        c2 = phi.right(j+1, 2);
        eqn.addToMatrix(globalID, globalID, diffCoefficient*(1 - c1));
        eqn.addToRHS(globalID, diffCoefficient*c2);
    end
end