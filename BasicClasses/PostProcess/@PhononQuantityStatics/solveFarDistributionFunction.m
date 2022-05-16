function solveFarDistributionFunction(obj, cc, sc)
    %>远平衡分布函数求解
    tic
    for k = 1 : cc.NW
        if sc.taoLA(k+1) ~= 0
            solven(obj.n(k).LA, obj.nDot(k).LA, cc, sc.gvLA(k+1), sc.taoLA(k+1));
        end
        if sc.taoTA(k+1) ~= 0
            solven(obj.n(k).TA, obj.nDot(k).TA, cc, sc.gvTA(k+1), sc.taoTA(k+1));
        end
        if sc.taoLO(k+1) ~= 0
            solven(obj.n(k).LO, obj.nDot(k).LO, cc, sc.gvLO(k+1), sc.taoLO(k+1));
        end
        if sc.taoTO(k+1) ~= 0
            solven(obj.n(k).TO, obj.nDot(k).TO, cc, sc.gvTO(k+1), sc.taoTO(k+1));
        end
    end
    disp(['远平衡分布函数求解完成！耗时：', sprintf('%.2f', toc), ' s'])
    
    function solven(field1, field2, cc, gv, tao)
        %>求解子函数
        massflux = StaggeredField(cc, gv, gv);
        sp = ColocateField(cc, 1/tao);
        Sc = ColocateField(cc);
        multiplyColocated(cc, Sc, field2, ColocateField(cc, -1));
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
        sourceOperator(eqn, cc, sp, Sc);
        eqn.solveMatrix(500);
        eqn.updateField(cc, field1);
    end
end