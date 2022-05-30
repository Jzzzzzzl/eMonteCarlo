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
        norm1 = norm(field1.data);
        errorMax = 1;
        vx = gv; vy = gv;
        while errorMax > 1e-7
            for i = 1 : cc.NX
                deltax = cc.modelx.face(i+1) - cc.modelx.face(i);
                for j = 1 : cc.NY
                    deltay = cc.modely.face(j+1) - cc.modely.face(j);
                    aW = vx/deltax;
                    aS = vy/deltay;
                    aP = aW + aS + 1/tao;
                    b = field2.data(i+1, j+1);
                    field1.data(i+1, j+1) = (aW*field1.data(i, j+1) + aS*field1.data(i+1, j) + b) / aP;
                end
            end
            norm2 = norm1;
            norm1 = norm(field1.data);
            errorMax = abs((norm2 - norm1)/norm1);
        end
    end
%     function solven(field1, field2, cc, gv, tao)
%         %>求解子函数
%         massflux = StaggeredField(cc, gv, gv);%这里的负号很重要
%         Sp = ColocateField(cc);
%         Sc = ColocateField(cc);
%         eqn = LinearSystem(cc.NX, cc.NY);
%         for i = 2 : cc.NX + 1
%             field1.top(i, :) = [0.0    0.0];
%             field1.bottom(i, :) = [0.0    0.0];
%         end
%         for j = 2 : cc.NY + 1
%             field1.left(j, :) = [0.0    0.0];
%             field1.right(j, :) = [0.0    0.0];
%         end
%         for m = 1 : 5
%             eqn.initialize;
%             eqn.setInitialGuess(cc, field1);
%             Sc.data = field1.data/tao;
%             minusColocated(cc, Sc, Sc, field2);
%             convectionOperator(eqn, cc, massflux, field1);
%             sourceOperator(eqn, cc, Sp, Sc);
%             eqn.solveMatrix(50);
%             eqn.updateField(cc, field1);
%         end
%     end
end