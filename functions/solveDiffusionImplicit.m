function [] = solveDiffusionImplicit(cc, pc, phi, source, item)
    %>系数矩阵迭代，结果与算子迭代相同
    deltax = cc.modelx.face(2) - cc.modelx.face(1);
    deltay = cc.modely.face(2) - cc.modely.face(1);
    
    for p = 1 : item
        for j = 2 : cc.NY+1
            A = zeros(cc.NX, cc.NX);
            B = zeros(cc.NX, 1);
            for i = 2 : cc.NX+1
                aE = pc.k * deltay / deltax;
                aW = pc.k * deltay / deltax;
                aN = pc.k * deltax / deltay;
                aS = pc.k * deltax / deltay;
                
                alphaW = 0; betaW = 0;
                alphaE = 0; betaE = 0;
                alphaN = 0; betaN = 0;
                alphaS = 0; betaS = 0;
                %>下边界
                if j == 2
                    alphaS = phi.bottom(i, 1);
                    betaS = phi.bottom(i, 2);
                    aS = 2 * aS;
                end
                %>上边界
                if j == cc.NY+1
                    alphaN = phi.top(i, 1);
                    betaN = phi.top(i, 2);
                    aN = 2 * aN;
                end
                %>左边界
                if i == 2
                    alphaW = phi.left(j, 1);
                    betaW = phi.left(j, 2);
                    aW = 2 * aW;
                end
                %>右边界
                if i == cc.NX+1
                    alphaE = phi.right(j, 1);
                    betaE = phi.right(j, 2);
                    aE = 2 * aE;
                end
                %>>>系数矩阵
                aP = -1 * (aW + aE + aN + aS) + alphaW*aW + alphaE*aE + alphaN*aN + alphaS*aS;
                b = source.data(i, j)*deltax*deltay + betaW * aW + betaE * aE + betaN * aN + betaS * aS;
                if (alphaN + betaN) ~= 0
                    b = (-1) * (b + aS * phi.data(i, j-1));
                elseif (alphaS + betaS) ~= 0
                    b = (-1) * (b + aN * phi.data(i, j+1));
                else
                    b = (-1) * (b + aN * phi.data(i, j+1) + aS * phi.data(i, j-1));
                end
                if i == 2
                    A(i-1, i-1) = aP;
                    A(i-1, i) = aE;
                elseif i == cc.NX+1
                    A(i-1, i-2) = aW;
                    A(i-1, i-1) = aP;
                else
                    A(i-1, i-2) = aW;
                    A(i-1, i-1) = aP;
                    A(i-1, i) = aE;
                end
                B(i-1) = b;
            end
            phi.data(2:cc.NX+1, j) = A \ B;
        end
    end
end