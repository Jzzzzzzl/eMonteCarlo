function computeTF(obj, cc, sc, pc)
    %>计算扩散温度
    sourceB = ColocateField(cc);
    for i = 1 : cc.NX
        for j = 1 : cc.NY
            energyLA = 0; energyTA = 0;
            energyLO = 0; energyTO = 0;
            for k = 1 : cc.NW
                deltaw = cc.frequency.face(k+1) - cc.frequency.face(k);
                if sc.gvLA(k+1) ~= 0
                    energyLA = energyLA + obj.n(k).LA.data(i+1, j+1)*pc.hbar*cc.frequency.point(k+1)*deltaw ...
                                 / (sc.gvLA(k+1)*sc.taoLA(k+1));
                end
                if sc.gvTA(k+1) ~= 0
                    energyTA = energyTA + obj.n(k).TA.data(i+1, j+1)*pc.hbar*cc.frequency.point(k+1)*deltaw ...
                                 / (sc.gvTA(k+1)*sc.taoTA(k+1));
                end
                if sc.gvLO(k+1) ~= 0
                    energyLO = energyLO + obj.n(k).LO.data(i+1, j+1)*pc.hbar*cc.frequency.point(k+1)*deltaw ...
                                 / (sc.gvLO(k+1)*sc.taoLO(k+1));
                end
                if sc.gvTO(k+1) ~= 0
                    energyTO = energyTO + obj.n(k).TO.data(i+1, j+1)*pc.hbar*cc.frequency.point(k+1)*deltaw ...
                                 / (sc.gvTO(k+1)*sc.taoTO(k+1));
                end
            end
            sourceB.data(i+1, j+1) = cc.xsforSourceB*(energyLA + energyTA + energyLO + energyTO) / (2*pi)^3;
        end
    end
    
    lambda = StaggeredField(cc, cc.k, cc.k);
    obj.TF = ColocateField(cc, cc.envTemp);
    sp = ColocateField(cc);
    Sc = sourceB;
    eqn = LinearSystem(cc.NX, cc.NY);
    for i = 2 : cc.NX + 1
        obj.TF.top(i, :) = [0.0    cc.envTemp];
        obj.TF.bottom(i, :) = [0.0    cc.envTemp];
    end
    for j = 2 : cc.NY + 1
        obj.TF.left(j, :) = [0.0    cc.envTemp];
        obj.TF.right(j, :) = [0.0    cc.envTemp];
    end
    eqn.initialize;
    eqn.setInitialGuess(cc, obj.TF);
    diffusionOperator(eqn, cc, lambda, obj.TF);
    sourceOperator(eqn, cc, sp, Sc);
    eqn.solveMatrix(500);
    eqn.updateField(cc, obj.TF);
    obj.TF.plotField(cc);
end