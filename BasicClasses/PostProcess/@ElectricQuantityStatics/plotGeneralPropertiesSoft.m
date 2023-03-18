function plotGeneralPropertiesSoft(obj, cc)
    %>各个属性画图
    figure
    %>电子平均能量随时间变化图
    subplot(2, 2, 1)
    if ~isempty(obj.aveETime)
        energys = zeros(cc.Nt, 1);
        for t = 1 : cc.Nt
            energys(t) = sum(obj.aveETime(t, :)) / sum(obj.aveETime(t, :) ~= 0);
        end
        slg = plot(cc.time.point(2:end-1)*1e12, energys/cc.e);
        slg.LineWidth = 2;
        %>写入文件
        writeDataToFile1D('aveEtime', cc, cc.time.point(2:end-1)*1e12, energys/cc.e)
    end
    xlabel("ps"); ylabel("eV");
    title("average electric energy")
    
    %>电子群能量分布图
    subplot(2, 2, 2)
    if ~isempty(obj.eNums)
        bar(cc.energy.point(2:end-1)/cc.e, obj.eNums);
        %>写入文件
        writeDataToFile1D('eNums', cc, cc.energy.point(2:end-1)/cc.e, obj.eNums)
    end
    xlabel("electron energy(eV)"); ylabel(".a.u")
    title("electron energy distribution");
    
    if cc.NX == 1
        %>此时为材料计算
        
        %>漂移速度随时间变化图
        subplot(2, 2, 3)
        if ~isempty(obj.driftVTime)
            slg = plot(cc.time.point(2:end-1)*1e12, obj.driftVTime*100);
            slg.LineWidth = 2;
            %>写入文件
            writeDataToFile1D('driftVTime', cc, cc.time.point(2:end-1)*1e12, obj.driftVTime*100);
        end
        xlabel("ps"); ylabel("cm/s");
        title("drift velocity")

        %>漂移速度随电场变化图
        subplot(2, 2, 4)
        if ~isempty(obj.driftVField)
            slg = semilogy(abs(cc.eFieldInput(:, 2))*100, obj.driftVField*100, '-*');
            slg.LineWidth = 2;
            %>写入文件
            writeDataToFile1D('driftVField', cc, abs(cc.eFieldInput(:, 2))*100, obj.driftVField*100)
        end
        xlabel("V/cm"); ylabel("cm/s");
        title("drift velocity with eField")
    else
        %>此时为器件计算
        %>电子平均能量随位置变化
        subplot(2, 2, 3)
        if ~isempty(obj.aveEPos)
            if cc.NY == 1
                slg = plot(cc.modelx.point(2:end-1)*1e9, obj.aveEPos/cc.e*1000);
                slg.LineWidth = 2;
                xlabel("nm"); ylabel("meV");
                title("average energy with position")
                %>写入文件
                writeDataToFile1D('aveEPos', cc, cc.modelx.point(2:end-1)*1e9, obj.aveEPos/cc.e*1000);
            else
                temp = ColocateField(cc);
                temp.data(2:end-1, 2:end-1) = obj.aveEPos/cc.e*1000;
                temp.plotField(cc);
                xlabel("nm"); ylabel("meV");
                title("average energy with position")
                %>写入文件
                writeDataToFile2D('aveEPos', cc, cc.modelx.face(1:end-1)*1e9, cc.modely.face(1:end-1)*1e9, ...
                                                        temp.data(2:end-1, 2:end-1));
            end
        end
    end
    
    
end