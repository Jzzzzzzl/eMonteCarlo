function solveFarDistributionFunction(obj, cc)
    %>远平衡分布函数求解
    for k = 1 : cc.NW
        if tao.LA(k+1) ~= 0
            solven(obj.n.LA, obj.nDot.LA, cc, gvLA(k+1), taoLA(k+1));
        end
        if tao.TA(k+1) ~= 0
            solven(obj.n.TA, obj.nDot.TA, cc, gvTA(k+1), taoTA(k+1));
        end
        if tao.LO(k+1) ~= 0
            solven(obj.n.LO, obj.nDot.LO, cc, gvLO(k+1), taoLO(k+1));
        end
        if tao.TO(k+1) ~= 0
            solven(obj.n.TO, obj.nDot.TO, cc, gvTO(k+1), taoTO(k+1));
        end
    end
    
    function solven(field1, field2, cc, gv, tao)
        %>求解子函数
        massflux = StaggeredField(cc, gv, gv);
        sp = ColocateField(cc, 1/tao);
        sc = ColocateField(cc);
        multiplyColocated(sc, field2, ColocateField(cc, -1));
        eqn = LinearSystem(cc.NX, cc.NY);
        for i = 2 : cc.NX + 1
            field1.top(i, :) = [0.0    0.0];
            field1.bottom(i, :) = [0.0    0.0];
        end
        for j = 2 : cc.NY + 1
            field1.left(j, :) = [0.0    0.0];
            field1.right(j, :) = [0.0    0.0];
        end
        eqn.initialize;
        eqn.setInitialGuess(cc, field1);
        convectionOperator(eqn, cc, massflux, field1);
        sourceOperator(eqn, cc, sp, sc);
        eqn.solveMatrix(50);
        eqn.updateField(cc, field1);
    end
end