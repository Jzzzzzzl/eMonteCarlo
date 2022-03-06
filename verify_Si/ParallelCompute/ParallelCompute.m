function [sh] = ParallelCompute(sh, bs, sr, sp, sc, pc, cc)
    %并行计算
    
    eGroup = sh.eGroup;
    pGroup = sh.pGroup;
    
    tic
    for k = 1 : cc.noFly
        for i = 1 : cc.superElecs
            % 散射段
            sr.ScatterringTable(eGroup(i), sc, pc, cc);
            sr.ComputeScatType;
            sr.ComputeFlyTime;
            eGroup(i).scatype = sr.scatType;
            [eGroup(i), pGroup(i)] = sp.ElectricScatProcess(eGroup(i), pGroup(i), bs, sc, pc, sr);
            % 自由飞行段
            eGroup(i) = FreeFlyProcess(eGroup(i), bs, sr, pc, cc);
        end
        %飞行完成后保存电子信息
        sh.eHistory(:, k) = eGroup;
        sh.pHistory(:, k) = pGroup;
        %输出计算进度
        disp(['计算进度： ', num2str(k / cc.noFly * 100), '%']);
    end
    toc
    
end