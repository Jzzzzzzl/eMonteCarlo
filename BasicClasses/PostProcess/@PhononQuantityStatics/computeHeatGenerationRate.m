function computeHeatGenerationRate(obj, pc, cc, sc)
    %>计算热产生率
    % 循环所有频率段，尤其注意不同极化支的频率范围
    tic
    for k = 2 : cc.NW
        deltaw = cc.frequency.face(cc.NW/2+1) - cc.frequency.face(cc.NW/2);
        % 扫描模型内部区域
        for i = 1 : cc.NX
            for j = 1 : cc.NY
                % 只能在极化支的频率定义域内进行计算
                if sc.dosLA(k+1) ~= 0
                    obj.Q(k).LA.data(i+1, j+1) = cc.eleConc.data(i+1, j+1) * pc.hbar * obj.allSumF(i, j, 1, k) / (cc.superElecs*obj.minimumTime);
                    obj.nDot(k).LA.data(i+1, j+1) = obj.Q(k).LA.data(i+1, j+1) / (pc.hbar*cc.frequency.point(k+1)*sc.dosLA(k+1)*deltaw)*cc.xsfornDot;
                end
                if sc.dosTA(k+1) ~= 0
                    obj.Q(k).TA.data(i+1, j+1) = cc.eleConc.data(i+1, j+1) * pc.hbar * obj.allSumF(i, j, 2, k) / (cc.superElecs*obj.minimumTime);
                    obj.nDot(k).TA.data(i+1, j+1) = obj.Q(k).TA.data(i+1, j+1) / (pc.hbar*cc.frequency.point(k+1)*sc.dosTA(k+1)*deltaw)*cc.xsfornDot;
                end
                if sc.dosLO(k+1) ~= 0
                    obj.Q(k).LO.data(i+1, j+1) = cc.eleConc.data(i+1, j+1) * pc.hbar * obj.allSumF(i, j, 3, k) / (cc.superElecs*obj.minimumTime);
                    obj.nDot(k).LO.data(i+1, j+1) = obj.Q(k).LO.data(i+1, j+1) / (pc.hbar*cc.frequency.point(k+1)*sc.dosLO(k+1)*deltaw)*cc.xsfornDot;
                end
                if sc.dosTO(k+1) ~= 0
                    obj.Q(k).TO.data(i+1, j+1) = cc.eleConc.data(i+1, j+1) * pc.hbar * obj.allSumF(i, j, 4, k) / (cc.superElecs*obj.minimumTime);
                    obj.nDot(k).TO.data(i+1, j+1) = obj.Q(k).TO.data(i+1, j+1) / (pc.hbar*cc.frequency.point(k+1)*sc.dosTO(k+1)*deltaw)*cc.xsfornDot;
                end
            end
        end
    end
    disp(['声子产热率计算结束！耗时：', sprintf('%.2f', toc), ' s'])
end