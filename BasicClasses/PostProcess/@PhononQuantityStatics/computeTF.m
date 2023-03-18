function computeTF(obj, cc, sc, pc)
    %>计算扩散温度
    tic
    sourceB = ColocateField(cc);
    for i = 1 : cc.NX
        for j = 1 : cc.NY
            energyLA = 0; energyTA = 0;
            energyLO = 0; energyTO = 0;
            for k = 1 : cc.NW
                deltaw = cc.frequency.face(k+1) - cc.frequency.face(k);
                if sc.gv.LA(k+1) ~= 0
                    energyLA = energyLA + obj.n(k).LA.data(i+1, j+1)*pc.hbar*cc.frequency.point(k+1)*deltaw ...
                                 / (sc.gv.LA(k+1)*sc.tao.LA(k+1));
                end
                if sc.gv.TA(k+1) ~= 0
                    energyTA = energyTA + obj.n(k).TA.data(i+1, j+1)*pc.hbar*cc.frequency.point(k+1)*deltaw ...
                                 / (sc.gv.TA(k+1)*sc.tao.TA(k+1));
                end
                if sc.gv.LO(k+1) ~= 0
                    energyLO = energyLO + obj.n(k).LO.data(i+1, j+1)*pc.hbar*cc.frequency.point(k+1)*deltaw ...
                                 / (sc.gv.LO(k+1)*sc.tao.LO(k+1));
                end
                if sc.gv.TO(k+1) ~= 0
                    energyTO = energyTO + obj.n(k).TO.data(i+1, j+1)*pc.hbar*cc.frequency.point(k+1)*deltaw ...
                                 / (sc.gv.TO(k+1)*sc.tao.TO(k+1));
                end
            end
            sourceB.data(i+1, j+1) = cc.xsforSourceB*(energyLA + energyTA + energyLO + energyTO) / (2*pi)^3;
        end
    end
    sourceB.plotField(cc, 'n')
    %>初始化及边界条件设置
    boudTemp = 300;
    obj.TF = ColocateField(cc, boudTemp);
    for i = 2 : cc.NX + 1
        obj.TF.top(i, :) = [1.0     0.0];
        obj.TF.bottom(i, :) = [1.0     0.0];
    end
    for j = 2 : cc.NY + 1
        obj.TF.left(j, :) = [0.0    boudTemp];
        obj.TF.right(j, :) = [0.0    boudTemp];
    end
    %>第一种计算方法（显式）
    Sp = ColocateField(cc);
    Sc = sourceB;
    lambda = StaggeredField(cc, pc.k, pc.k);
    eqn = LinearSystem(cc.NX, cc.NY);
    for i = 1 : 50
        eqn.initialize;
        eqn.setInitialGuess(cc, obj.TF);
        diffusionOperator(eqn, cc, lambda, obj.TF);
        sourceOperator(eqn, cc, Sp, Sc);
        eqn.solveMatrix(1000);
        eqn.updateField(cc, obj.TF);
    end
    %>第二种计算方法（半隐式）
%     solveDiffusionImplicit(cc, pc, obj.TF, sourceB, 50000);
    %>写入文件
    if cc.NY == 1
        writeDataToFile1D('TF', cc, cc.modelx.point(2:end-1)*1e9, obj.TF.data(2:end-1, cc.NY+1));
    else
        writeDataToFile2D('TF', cc, cc.modelx.face(1:end-1)*1e9, cc.modely.face(1:end-1)*1e9, ...
                                        obj.TF.data(2:end-1, 2:end-1));
    end
    disp(['扩散温度求解完成！耗时：', sprintf('%.2f', toc), ' s'])
end