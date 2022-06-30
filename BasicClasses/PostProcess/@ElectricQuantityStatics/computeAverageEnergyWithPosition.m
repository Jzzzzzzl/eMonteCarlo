function computeAverageEnergyWithPosition(obj, cc)
    %>计算平均能量随位置变化
    tic
    obj.aveEPos = ColocateField(cc);
    aveepos = zeros(cc.NX+2, cc.NY+2);
    startMatlabPool(cc.localWorkers);
    spmd
        No = cc.pjobIndexs(labindex, 1);
        while No <= cc.pjobIndexs(labindex, 2)
            [i, j] = getInverseGlobalID(cc.NX, cc.NY, No);
            lb = cc.modelx.face(i);
            rb = cc.modelx.face(i+1);
            tb = cc.modely.face(j+1);
            bb = cc.modely.face(j);
            num1 = 0;
            num2 = 0;
            eTemp = 0;
            eSum = 0;
            for k = 1 : cc.superElecs
                x = squeeze(obj.positions(1, 1, k, :));
                y = squeeze(obj.positions(1, 2, k, :));
                index = x > lb & x < rb & y < tb & y > bb;
                eTemp = obj.energys(k, index);
                num1 = length(eTemp);
                if num1 ~= 0
                    eSum = eSum + sum(eTemp) / num1;
                    num2 = num2 + 1;
                end
            end
            aveepos(i+1, j+1) = eSum / num2;
            No = No + 1;
        end
    end
    for i = 2 : cc.localWorkers
        aveepos{1} = aveepos{1} + aveepos{i};
    end
    obj.aveEPos.data = aveepos{1} / cc.e * 1000;
    disp(['平均能量随位置变化计算完成！耗时：', sprintf('%.2f', toc), ' s'])
end