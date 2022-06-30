function [] = parallelCompute(sh, dv, sc, pc, cc)
    %% 并行计算
    eGroup = sh.eGroup;
    pGroup = sh.pGroup;
    
    tic
    startMatlabPool(cc.localWorkers);
    for k = 1 : cc.noFly
        parfor i = 1 : cc.superElecs
            %自由飞行段
            eGroup(i) = freeFlyProcess(eGroup(i), dv, pc);
            %散射段
            cc.computePositionParameters(eGroup(i));
            dv.valleyGuidingPrinciple(eGroup(i));
            dv.valley.scatteringTable(eGroup(i), sc, pc);
            dv.valley.computeScatType;
            eGroup(i).scatype = dv.valley.scatType;
            [eGroup(i), pGroup(i)] = dv.valley.scatteringProcess(dv, eGroup(i), pGroup(i), sc, pc);
        end
        %飞行完成后写入电声子信息
        getFileID(cc, k);
        writeToElectricLogFile(cc.elog, eGroup, cc, k);
        writeToPhononLogFile(cc.plog, pGroup, cc);
        %输出计算进度
        disp(['计算进度： ', sprintf('%.2f', k / cc.noFly * 100), '%']);
    end
    fclose(cc.elog);
    fclose(cc.plog);
    disp(['计算总用时： ', sprintf('%.2f', toc), ' s']);
    
end