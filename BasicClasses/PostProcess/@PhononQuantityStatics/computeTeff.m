function computeTeff(obj, cc, pc, sc, type)
    %>计算等效温度
    tic
    obj.Teff = ColocateField(cc, cc.initTemp);
    teff = obj.TF.data;
    number = 200;
    deltaT = 1;
    errorMax = 1e-3;
    error = zeros(number, 1);
    flag = -1;% 用于控制温度增减
    startMatlabPool(cc.localWorkers);
    njobs = floor(cc.NX*cc.NY/cc.localWorkers)+1;
    indexs = zeros(cc.localWorkers, 2);
    for i = 1 : cc.localWorkers
        indexs(i, 1) = 1 + njobs * (i - 1);
        indexs(i, 2) = indexs(i, 1) + njobs - 1;
    end
    indexs(end, 2) = cc.NX*cc.NY;
    spmd
        No = indexs(labindex, 1);
        while No <= indexs(labindex, 2)
            [i, j] = getInverseGlobalID(cc.NX, cc.NY, No);
            for p = 1 : number
                % 方程左边
                energyLA = 0; energyTA = 0;
                energyLO = 0; energyTO = 0;
                for k = 2 : cc.NW
                    deltaw = cc.frequency.face(k+1) - cc.frequency.face(k);
                    NLeft = 1 / (exp(pc.hbar*cc.frequency.point(k+1) / (pc.kb*teff(i+1, j+1))) - 1);
                    switch type
                        case 'LA'
                            if sc.gvLA(k+1) ~= 0
                                energyLA = energyLA + NLeft*pc.hbar*cc.frequency.point(k+1)*deltaw / sc.gvLA(k+1);
                            end
                        case 'TA'
                            if sc.gvTA(k+1) ~= 0
                                energyTA = energyTA + NLeft*pc.hbar*cc.frequency.point(k+1)*deltaw / sc.gvTA(k+1);
                            end
                        case 'LO'
                            if sc.gvLO(k+1) ~= 0
                                energyLO = energyLO + NLeft*pc.hbar*cc.frequency.point(k+1)*deltaw / sc.gvLO(k+1);
                            end
                        case 'TO'
                            if sc.gvTO(k+1) ~= 0
                                energyTO = energyTO + NLeft*pc.hbar*cc.frequency.point(k+1)*deltaw / sc.gvTO(k+1);
                            end
                        case 'ALL'
                            if sc.gvLA(k+1) ~= 0
                                energyLA = energyLA + NLeft*pc.hbar*cc.frequency.point(k+1)*deltaw / sc.gvLA(k+1);
                            end
                            if sc.gvTA(k+1) ~= 0
                                energyTA = energyTA + NLeft*pc.hbar*cc.frequency.point(k+1)*deltaw / sc.gvTA(k+1);
                            end
                            if sc.gvLO(k+1) ~= 0
                                energyLO = energyLO + NLeft*pc.hbar*cc.frequency.point(k+1)*deltaw / sc.gvLO(k+1);
                            end
                            if sc.gvTO(k+1) ~= 0
                                energyTO = energyTO + NLeft*pc.hbar*cc.frequency.point(k+1)*deltaw / sc.gvTO(k+1);
                            end
                    end
                end
                energyLeft = (energyLA + energyTA + energyLO + energyTO) / (2*pi)^3;
                % 方程右边
                energyLA = 0; energyTA = 0;
                energyLO = 0; energyTO = 0;
                for k = 2 : cc.NW
                    deltaw = cc.frequency.face(k+1) - cc.frequency.face(k);
                    NRight = 1 / (exp(pc.hbar*cc.frequency.point(k+1) / (pc.kb*obj.TF.data(i+1, j+1))) - 1);
                    switch type
                        case 'LA'
                            if sc.gvLA(k+1) ~= 0
                                energyLA = energyLA + (obj.n(k).LA.data(i+1, j+1) + NRight)*pc.hbar*cc.frequency.point(k+1)*deltaw / sc.gvLA(k+1);
                            end
                        case 'TA'
                            if sc.gvTA(k+1) ~= 0
                                energyTA = energyTA + (obj.n(k).TA.data(i+1, j+1) + NRight)*pc.hbar*cc.frequency.point(k+1)*deltaw / sc.gvTA(k+1);
                            end
                        case 'LO'
                            if sc.gvLO(k+1) ~= 0
                                energyLO = energyLO + (obj.n(k).LO.data(i+1, j+1) + NRight)*pc.hbar*cc.frequency.point(k+1)*deltaw / sc.gvLO(k+1);
                            end
                        case 'TO'
                            if sc.gvTO(k+1) ~= 0
                                energyTO = energyTO + (obj.n(k).TO.data(i+1, j+1) + NRight)*pc.hbar*cc.frequency.point(k+1)*deltaw / sc.gvTO(k+1);
                            end
                        case 'ALL'
                            if sc.gvLA(k+1) ~= 0
                                energyLA = energyLA + (obj.n(k).LA.data(i+1, j+1) + NRight)*pc.hbar*cc.frequency.point(k+1)*deltaw / sc.gvLA(k+1);
                            end
                            if sc.gvTA(k+1) ~= 0
                                energyTA = energyTA + (obj.n(k).TA.data(i+1, j+1) + NRight)*pc.hbar*cc.frequency.point(k+1)*deltaw / sc.gvTA(k+1);
                            end
                            if sc.gvLO(k+1) ~= 0
                                energyLO = energyLO + (obj.n(k).LO.data(i+1, j+1) + NRight)*pc.hbar*cc.frequency.point(k+1)*deltaw / sc.gvLO(k+1);
                            end
                            if sc.gvTO(k+1) ~= 0
                                energyTO = energyTO + (obj.n(k).TO.data(i+1, j+1) + NRight)*pc.hbar*cc.frequency.point(k+1)*deltaw / sc.gvTO(k+1);
                            end
                    end
                end
                energyRight = (energyLA + energyTA + energyLO + energyTO) / (2*pi)^3;
                % 左右校准
                error(p) = double(abs((energyRight - energyLeft) / energyRight));
                if error(p) < errorMax
                    break;
                end
                if p >= 2 && (error(p) - error(p-1)) > 0
                    flag = -1*flag;
                end
                teff(i+1, j+1) = teff(i+1, j+1) + flag*deltaT;
            end
            No = No + 1;
        end
    end
    obj.Teff.data = teff{1};
    for i = 2 : cc.localWorkers
        obj.Teff.data = obj.Teff.data + teff{i};
    end
    obj.Teff.data = obj.Teff.data/cc.localWorkers;
    obj.Teff.plotField(cc)
    hold on
    plot(cc.modelx.point, obj.TF.data(:, 2), 'LineWidth', 2)
    legend([string(type) "TF"])
    disp(['等效温度求解完成！耗时：', sprintf('%.2f', toc), ' s'])
end