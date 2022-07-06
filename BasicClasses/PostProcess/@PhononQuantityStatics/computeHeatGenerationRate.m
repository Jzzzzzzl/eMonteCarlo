function computeHeatGenerationRate(obj, pc, cc, sc)
    %>计算热产生率
    % 循环所有频率段，尤其注意不同极化支的频率范围
    tic
    deltat = obj.maxTime - obj.minTime;
    for k = 2 : cc.NW %>>>>>>>>>>>这里的频率段从2开始，可能有问题？
        deltaw = cc.frequency.face(cc.NW/2+1) - cc.frequency.face(cc.NW/2);
        % 扫描模型内部区域
        for i = 1 : cc.NX
            for j = 1 : cc.NY
                % 只能在极化支的频率定义域内进行计算
                if sc.dos.LA(k+1) ~= 0
                    obj.Q(k).LA.data(i+1, j+1) = cc.eleConc.data(i+1, j+1) * pc.hbar * obj.allSumF(i, j, 1, k) / (cc.superElecs*deltat)*cc.xsforQ;
                    obj.nDot(k).LA.data(i+1, j+1) = obj.Q(k).LA.data(i+1, j+1) / (pc.hbar*cc.frequency.point(k+1)*sc.dos.LA(k+1)*deltaw);
                end
                if sc.dos.TA(k+1) ~= 0
                    obj.Q(k).TA.data(i+1, j+1) = cc.eleConc.data(i+1, j+1) * pc.hbar * obj.allSumF(i, j, 2, k) / (cc.superElecs*deltat)*cc.xsforQ;
                    obj.nDot(k).TA.data(i+1, j+1) = obj.Q(k).TA.data(i+1, j+1) / (pc.hbar*cc.frequency.point(k+1)*sc.dos.TA(k+1)*deltaw);
                end
                if sc.dos.LO(k+1) ~= 0
                    obj.Q(k).LO.data(i+1, j+1) = cc.eleConc.data(i+1, j+1) * pc.hbar * obj.allSumF(i, j, 3, k) / (cc.superElecs*deltat)*cc.xsforQ;
                    obj.nDot(k).LO.data(i+1, j+1) = obj.Q(k).LO.data(i+1, j+1) / (pc.hbar*cc.frequency.point(k+1)*sc.dos.LO(k+1)*deltaw);
                end
                if sc.dos.TO(k+1) ~= 0
                    obj.Q(k).TO.data(i+1, j+1) = cc.eleConc.data(i+1, j+1) * pc.hbar * obj.allSumF(i, j, 4, k) / (cc.superElecs*deltat)*cc.xsforQ;
                    obj.nDot(k).TO.data(i+1, j+1) = obj.Q(k).TO.data(i+1, j+1) / (pc.hbar*cc.frequency.point(k+1)*sc.dos.TO(k+1)*deltaw);
                end
            end
        end
    end
    disp(['声子产热率计算结束！耗时：', sprintf('%.2f', toc), ' s'])
end