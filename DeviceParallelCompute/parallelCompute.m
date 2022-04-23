function [sh] = parallelCompute(sh, dv, sc, pc, cc)
    %% 并行计算
    eGroup = sh.eGroup;
    pGroup = sh.pGroup;
    
    tic
    for k = 1 : cc.noFly
        parfor i = 1 : cc.superElecs
            %自由飞行段
            eGroup(i) = freeFlyProcess(eGroup(i), dv, pc, cc);
            %散射段
            dv.valleyGuidingPrinciple(eGroup(i));%似乎不必要
            dv.valley.scatteringTable(eGroup(i), sc, pc, cc);
            dv.valley.computeScatType;
            eGroup(i).scatype = dv.valley.scatType;
            [eGroup(i), pGroup(i)] = dv.valley.scatteringProcess(dv, eGroup(i), pGroup(i), sc, pc);
        end
        %飞行完成后保存电子信息
        sh.eHistory(:, k) = eGroup;
        sh.pHistory(:, k) = pGroup;
        %输出计算进度
        disp(['计算进度： ', sprintf('%.2f', k / cc.noFly * 100), '%']);
    end
    disp(['计算总用时： ', sprintf('%.2f', toc), ' s']);
    
end