function computeTeff(obj, cc, pc, sc, type)
    %>计算等效温度
    tic
    teff = obj.TF.data;
    number = 200;
    deltaT = 1;
    errorMax = 1e-3;
    error = zeros(number, 1);
    flag = -1;% 用于控制温度增减
    startMatlabPool(cc.localWorkers);
    spmd
        No = cc.pjobIndexs(labindex, 1);
        while No <= cc.pjobIndexs(labindex, 2)
            [i, j] = getInverseGlobalID(cc.NX, cc.NY, No);
            for p = 1 : number
                % 方程左边
                energyLA = 0; energyTA = 0;
                energyLO = 0; energyTO = 0;
                for k = 2 : cc.NW
                    deltaw = cc.frequency.face(k+1) - cc.frequency.face(k);
                    NLeft = 1 / (exp(pc.hbar*cc.frequency.point(k+1) / (pc.kb*teff(i+1, j+1))) - 1);
                    switch type
                        case 1
                            if sc.gv.LA(k+1) ~= 0
                                energyLA = energyLA + NLeft*pc.hbar*cc.frequency.point(k+1)*deltaw / sc.gv.LA(k+1);
                            end
                        case 2
                            if sc.gv.TA(k+1) ~= 0
                                energyTA = energyTA + NLeft*pc.hbar*cc.frequency.point(k+1)*deltaw / sc.gv.TA(k+1);
                            end
                        case 3
                            if sc.gv.LO(k+1) ~= 0
                                energyLO = energyLO + NLeft*pc.hbar*cc.frequency.point(k+1)*deltaw / sc.gv.LO(k+1);
                            end
                        case 4
                            if sc.gv.TO(k+1) ~= 0
                                energyTO = energyTO + NLeft*pc.hbar*cc.frequency.point(k+1)*deltaw / sc.gv.TO(k+1);
                            end
                        case 5
                            if sc.gv.LA(k+1) ~= 0
                                energyLA = energyLA + NLeft*pc.hbar*cc.frequency.point(k+1)*deltaw / sc.gv.LA(k+1);
                            end
                            if sc.gv.TA(k+1) ~= 0
                                energyTA = energyTA + NLeft*pc.hbar*cc.frequency.point(k+1)*deltaw / sc.gv.TA(k+1);
                            end
                            if sc.gv.LO(k+1) ~= 0
                                energyLO = energyLO + NLeft*pc.hbar*cc.frequency.point(k+1)*deltaw / sc.gv.LO(k+1);
                            end
                            if sc.gv.TO(k+1) ~= 0
                                energyTO = energyTO + NLeft*pc.hbar*cc.frequency.point(k+1)*deltaw / sc.gv.TO(k+1);
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
                        case 1
                            if sc.gv.LA(k+1) ~= 0
                                energyLA = energyLA + (obj.n(k).LA.data(i+1, j+1) + NRight)*pc.hbar*cc.frequency.point(k+1)*deltaw / sc.gv.LA(k+1);
                            end
                        case 2
                            if sc.gv.TA(k+1) ~= 0
                                energyTA = energyTA + (obj.n(k).TA.data(i+1, j+1) + NRight)*pc.hbar*cc.frequency.point(k+1)*deltaw / sc.gv.TA(k+1);
                            end
                        case 3
                            if sc.gv.LO(k+1) ~= 0
                                energyLO = energyLO + (obj.n(k).LO.data(i+1, j+1) + NRight)*pc.hbar*cc.frequency.point(k+1)*deltaw / sc.gv.LO(k+1);
                            end
                        case 4
                            if sc.gv.TO(k+1) ~= 0
                                energyTO = energyTO + (obj.n(k).TO.data(i+1, j+1) + NRight)*pc.hbar*cc.frequency.point(k+1)*deltaw / sc.gv.TO(k+1);
                            end
                        case 5
                            if sc.gv.LA(k+1) ~= 0
                                energyLA = energyLA + (obj.n(k).LA.data(i+1, j+1) + NRight)*pc.hbar*cc.frequency.point(k+1)*deltaw / sc.gv.LA(k+1);
                            end
                            if sc.gv.TA(k+1) ~= 0
                                energyTA = energyTA + (obj.n(k).TA.data(i+1, j+1) + NRight)*pc.hbar*cc.frequency.point(k+1)*deltaw / sc.gv.TA(k+1);
                            end
                            if sc.gv.LO(k+1) ~= 0
                                energyLO = energyLO + (obj.n(k).LO.data(i+1, j+1) + NRight)*pc.hbar*cc.frequency.point(k+1)*deltaw / sc.gv.LO(k+1);
                            end
                            if sc.gv.TO(k+1) ~= 0
                                energyTO = energyTO + (obj.n(k).TO.data(i+1, j+1) + NRight)*pc.hbar*cc.frequency.point(k+1)*deltaw / sc.gv.TO(k+1);
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
    
    for i = 2 : cc.localWorkers
        teff{1} = teff{1} + teff{i};
    end
    teff{1} = teff{1}/cc.localWorkers;
    switch type
        case 1
            obj.pTeff.LA.data = teff{1};
            %>写入文件
            if cc.NY == 1
                writeDataToFile1D('LA_Teff', cc, cc.modelx.point(2:end-1)*1e9, obj.pTeff.LA.data(2:end-1, cc.NY+1));
            else
                writeDataToFile2D('LA_Teff', cc, cc.modelx.face(1:end-1)*1e9, cc.modely.face(1:end-1)*1e9, ...
                                                       obj.pTeff.LA.data(2:end-1, 2:end-1));
            end
        case 2
            obj.pTeff.TA.data = teff{1};
            %>写入文件
            if cc.NY == 1
                writeDataToFile1D('TA_Teff', cc, cc.modelx.point(2:end-1)*1e9, obj.pTeff.TA.data(2:end-1, cc.NY+1));
            else
                writeDataToFile2D('TA_Teff', cc, cc.modelx.face(1:end-1)*1e9, cc.modely.face(1:end-1)*1e9, ...
                                                       obj.pTeff.TA.data(2:end-1, 2:end-1));
            end
        case 3
            obj.pTeff.LO.data = teff{1};
            %>写入文件
            if cc.NY == 1
                writeDataToFile1D('LO_Teff', cc, cc.modelx.point(2:end-1)*1e9, obj.pTeff.LO.data(2:end-1, cc.NY+1));
            else
                writeDataToFile2D('LO_Teff', cc, cc.modelx.face(1:end-1)*1e9, cc.modely.face(1:end-1)*1e9, ...
                                                       obj.pTeff.LO.data(2:end-1, 2:end-1));
            end
        case 4
            obj.pTeff.TO.data = teff{1};
            %>写入文件
            if cc.NY == 1
                writeDataToFile1D('TO_Teff', cc, cc.modelx.point(2:end-1)*1e9, obj.pTeff.TO.data(2:end-1, cc.NY+1));
            else
                writeDataToFile2D('TO_Teff', cc, cc.modelx.face(1:end-1)*1e9, cc.modely.face(1:end-1)*1e9, ...
                                                       obj.pTeff.TO.data(2:end-1, 2:end-1));
            end
        case 5
            obj.Teff.data = teff{1};
            %>写入文件
            if cc.NY == 1
                writeDataToFile1D('ALL_Teff', cc, cc.modelx.point(2:end-1)*1e9, obj.Teff.data(2:end-1, cc.NY+1));
            else
                writeDataToFile2D('ALL_Teff', cc, cc.modelx.face(1:end-1)*1e9, cc.modely.face(1:end-1)*1e9, ...
                                                       obj.Teff.data(2:end-1, 2:end-1));
            end
    end
    disp(['等效温度求解完成！耗时：', sprintf('%.2f', toc), ' s'])
end