function solveFarDistributionFunction(obj, cc, sc)
    %>远平衡分布函数求解
    tic
    deltax = cc.modelx.face(2) - cc.modelx.face(1);
    deltay = cc.modely.face(2) - cc.modely.face(1);
    nMatrix = zeros(cc.NX+2, cc.NY+2, cc.NW, 4);
    startMatlabPool(cc.localWorkers);
    spmd
%         labindex = 1;
        No = obj.fjobIndexs(labindex, 1);
        while No <= obj.fjobIndexs(labindex, 2)
            for i = 1 : cc.NA
                %>LA
                vx = cos(cc.angle.point(i+1))*abs(sc.gv.LA(No+1));
                vy = sin(cc.angle.point(i+1))*abs(sc.gv.LA(No+1));
                if sc.tao.LA(No+1) ~= 0
                    nMatrix(:, :, No, 1) = nMatrix(:, :, No, 1) + solven(obj.nDot(No).LA.data, deltax, deltay, vx, vy, sc.tao.LA(No+1));
                end
                %>TA
                vx = cos(cc.angle.point(i+1))*abs(sc.gv.TA(No+1));
                vy = sin(cc.angle.point(i+1))*abs(sc.gv.TA(No+1));
                if sc.tao.TA(No+1) ~= 0
                    nMatrix(:, :, No, 2) = nMatrix(:, :, No, 2) + solven(obj.nDot(No).TA.data, deltax, deltay, vx, vy, sc.tao.TA(No+1));
                end
                %>LO
                vx = cos(cc.angle.point(i+1))*abs(sc.gv.LO(No+1));
                vy = sin(cc.angle.point(i+1))*abs(sc.gv.LO(No+1));
                if sc.tao.LO(No+1) ~= 0
                    nMatrix(:, :, No, 3) = nMatrix(:, :, No, 3) + solven(obj.nDot(No).LO.data, deltax, deltay, vx, vy, sc.tao.LO(No+1));
                end
                %>TO
                vx = cos(cc.angle.point(i+1))*abs(sc.gv.TO(No+1));
                vy = sin(cc.angle.point(i+1))*abs(sc.gv.TO(No+1));
                if sc.tao.TO(No+1) ~= 0
                    nMatrix(:, :, No, 4) = nMatrix(:, :, No, 4) + solven(obj.nDot(No).TO.data, deltax, deltay, vx, vy, sc.tao.TO(No+1));
                end
            end
            No = No + 1;
        end
    end
    for i = 2 : cc.localWorkers
        nMatrix{1} = nMatrix{1} + nMatrix{i};
    end
    nMatrixs = nMatrix{1};
    for k = 1 : cc.NW
        obj.n(k).LA.data = nMatrixs(:, :, k, 1)/cc.NA;
        obj.n(k).TA.data = nMatrixs(:, :, k, 2)/cc.NA;
        obj.n(k).LO.data = nMatrixs(:, :, k, 3)/cc.NA;
        obj.n(k).TO.data = nMatrixs(:, :, k, 4)/cc.NA;
    end
%     for k = 1 : cc.NW
%         if sc.tao.LA(k+1) ~= 0
%             obj.n(k).LA.data = solven(obj.nDot(k).LA.data, deltax, deltay, sc.gv.LA(k+1), sc.gv.LA(k+1), sc.tao.LA(k+1));
%         end
%         if sc.tao.TA(k+1) ~= 0
%             obj.n(k).TA.data = solven(obj.nDot(k).TA.data, deltax, deltay, sc.gv.TA(k+1), sc.gv.TA(k+1), sc.tao.TA(k+1));
%         end
%         if sc.tao.LO(k+1) ~= 0
%             obj.n(k).LO.data = solven(obj.nDot(k).LO.data, deltax, deltay, sc.gv.LO(k+1), sc.gv.LO(k+1), sc.tao.LO(k+1));
%         end
%         if sc.tao.TO(k+1) ~= 0
%             obj.n(k).TO.data = solven(obj.nDot(k).TO.data, deltax, deltay, sc.gv.TO(k+1), sc.gv.TO(k+1), sc.tao.TO(k+1));
%         end
%     end
    disp(['远平衡分布函数求解完成！耗时：', sprintf('%.2f', toc), ' s'])
    %>Matlab实现
%     function solven(field1, field2, cc, vx, vy, tao)
%         %>
%         norm1 = norm(field1.data);
%         errorMax = 1;
%         deltax = cc.modelx.face(2) - cc.modelx.face(1);
%         deltay = cc.modely.face(2) - cc.modely.face(1);
%         if vx >= 0
%             aW = vx / deltax;
%             aE = 0;
%         else
%             aW = 0;
%             aE = -1 * vx / deltax;
%         end
%         if vy >= 0
%             aS = vy / deltay;
%             aN = 0;
%         else
%             aS = 0;
%             aN = -1 * vy / deltay;
%         end
%         aP = aW + aE + aS + aN + 1/tao;
%         while errorMax > 1e-7
%             for i = 1 : cc.NX
%                 for j = 1 : cc.NY
%                     nW = field1.data(i, j+1);
%                     nE = field1.data(i+2, j+1);
%                     nS = field1.data(i+1, j);
%                     nN = field1.data(i+1, j+2);
%                     field1.data(i+1, j+1) = (aW*nW+aE*nE+aS*nS+aN*nN+field2.data(i+1, j+1))/aP;
%                 end
%             end
%             norm2 = norm1;
%             norm1 = norm(field1.data);
%             errorMax = abs((norm2 - norm1)/norm1);
%         end
%     end
    %>Operator离散算子实现
%     for k = 1 : cc.NW
%         if sc.tao.LA(k+1) ~= 0
%             solven(obj.n(k).LA, obj.nDot(k).LA, cc, -sc.gv.LA(k+1), sc.gv.LA(k+1), sc.tao.LA(k+1));
%         end
%         if sc.tao.TA(k+1) ~= 0
%             solven(obj.n(k).TA, obj.nDot(k).TA, cc, -sc.gv.TA(k+1), sc.gv.TA(k+1), sc.tao.TA(k+1));
%         end
%         if sc.tao.LO(k+1) ~= 0
%             solven(obj.n(k).LO, obj.nDot(k).LO, cc, -sc.gv.LO(k+1), sc.gv.LO(k+1), sc.tao.LO(k+1));
%         end
%         if sc.tao.TO(k+1) ~= 0
%             solven(obj.n(k).TO, obj.nDot(k).TO, cc, -sc.gv.TO(k+1), sc.gv.TO(k+1), sc.tao.TO(k+1));
%         end
%     end
%     function solven(field1, field2, cc, vx, vy, tao)
%         %>求解子函数
%         massflux = StaggeredField(cc, vx, vy);
%         Sps = ColocateField(cc);
%         Scs = ColocateField(cc);
%         Spo = ColocateField(cc, -1/tao);
%         eqn = LinearSystem(cc.NX, cc.NY);
%         for i = 2 : cc.NX + 1
%             field1.top(i, :) = [0.0    0.0];
%             field1.bottom(i, :) = [0.0    0.0];
%         end
%         for j = 2 : cc.NY + 1
%             field1.left(j, :) = [0.0    0.0];
%             field1.right(j, :) = [0.0    0.0];
%         end
%         eqn.initialize;
%         eqn.setInitialGuess(cc, field1);
%         Scs.data = field2.data;
%         convectionOperator(eqn, cc, massflux, field1);
%         sourceOperator(eqn, cc, Sps, Scs);
%         oneTermOperator(eqn, cc, Spo);
%         eqn.solveMatrix(500);
%         eqn.updateField(cc, field1);
%     end
end