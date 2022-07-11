function [] = parallelCompute(sh, dv, sc, pc, cc)
    %% 并行计算
    eGroup = sh.eGroup;
    pGroup = sh.pGroup;
    
    tic
    startMatlabPool(cc.localWorkers);
    spmd
        cc.getFileID(labindex);
        i = cc.ejobIndexs(labindex, 1);
        while i <= cc.ejobIndexs(labindex, 2)
            for k = 1 : cc.noFly
                eGroup(i) = freeFlyProcess(eGroup(i), dv, pc);
                %散射段
                cc.computePositionParameters(eGroup(i));
                dv.valleyGuidingPrinciple(eGroup(i));
                dv.valley.scatteringTable(eGroup(i), sc, pc);
                dv.valley.rejectScatteringType(cc, eGroup(i));
                eGroup(i).scatype = dv.valley.scatType;
                [eGroup(i), pGroup(i)] = dv.valley.scatteringProcess(dv, eGroup(i), pGroup(i), sc, pc);
                %飞行完成后写入电声子信息
                writeToElectricLogFile(cc.elog, eGroup(i), k);
                writeToPhononLogFile(cc.plog, pGroup(i));
            end
            %输出计算进度
            disp(['计算进度： ', sprintf('%.2f', (i-cc.ejobIndexs(labindex, 1)+1) ...
                   / (cc.ejobIndexs(labindex, 2) - cc.ejobIndexs(labindex, 1)+1) * 100), '%']);
            i = i + 1;
        end
    end
    disp(['计算总用时： ', sprintf('%.2f', toc), ' s']);
end