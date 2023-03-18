function plotFullFrequencyPeoperties(obj, field, cc, type)
    %>检验nDot及n的大小
    sumN = repmat(obj.polar, 1, 1);
    sumN.LA = ColocateField(cc);
    sumN.TA = ColocateField(cc);
    sumN.LO = ColocateField(cc);
    sumN.TO = ColocateField(cc);
    sumN.ALL = ColocateField(cc);
    
    for k = 1 : cc.NW
        sumN.LA.data = sumN.LA.data + field(k).LA.data;
        sumN.TA.data = sumN.TA.data + field(k).TA.data;
        sumN.LO.data = sumN.LO.data + field(k).LO.data;
        sumN.TO.data = sumN.TO.data + field(k).TO.data;
        sumN.ALL.data = sumN.ALL.data + field(k).LA.data + field(k).TA.data ...
                                                     + field(k).LO.data + field(k).TO.data;
    end
    %>写入文件
    if cc.NY == 1
        writeDataToFile1D(['sum_' type '_LA'], cc, cc.modelx.point(2:end-1)*1e9, ...
                                                            sumN.LA.data((2:end-1), cc.NY+1));
        writeDataToFile1D(['sum_' type '_TA'], cc, cc.modelx.point(2:end-1)*1e9, ...
                                                            sumN.TA.data((2:end-1), cc.NY+1));
        writeDataToFile1D(['sum_' type '_LO'], cc, cc.modelx.point(2:end-1)*1e9, ...
                                                            sumN.LO.data((2:end-1), cc.NY+1));
        writeDataToFile1D(['sum_' type '_TO'], cc, cc.modelx.point(2:end-1)*1e9, ...
                                                            sumN.TO.data((2:end-1), cc.NY+1));
        writeDataToFile1D(['sum_' type '_ALL'], cc, cc.modelx.point(2:end-1)*1e9, ...
                                                            sumN.ALL.data((2:end-1), cc.NY+1));
        %>一维画图,可画在同一幅画布中
        figure
        hold on
        plot(cc.modelx.point*1e9, sumN.LA.data(:, cc.NY+1), 'LineWidth', 2)
        plot(cc.modelx.point*1e9, sumN.TA.data(:, cc.NY+1), 'LineWidth', 2)
        plot(cc.modelx.point*1e9, sumN.LO.data(:, cc.NY+1), 'LineWidth', 2)
        plot(cc.modelx.point*1e9, sumN.TO.data(:, cc.NY+1), 'LineWidth', 2)
        plot(cc.modelx.point*1e9, sumN.ALL.data(:, cc.NY+1), 'LineWidth', 2)
        legend(["LA" "TA" "LO" "TO" "ALL"])
    else
        writeDataToFile2D(['sum_' type '_LA'], cc, cc.modelx.face(1:end-1)*1e9, cc.modely.face(1:end-1)*1e9, ...
                                                            sumN.LA.data(2:end-1, 2:end-1));
        writeDataToFile2D(['sum_' type '_TA'], cc, cc.modelx.face(1:end-1)*1e9, cc.modely.face(1:end-1)*1e9, ...
                                                            sumN.TA.data(2:end-1, 2:end-1));
        writeDataToFile2D(['sum_' type '_LO'], cc, cc.modelx.face(1:end-1)*1e9, cc.modely.face(1:end-1)*1e9, ...
                                                            sumN.LO.data(2:end-1, 2:end-1));
        writeDataToFile2D(['sum_' type '_TO'], cc, cc.modelx.face(1:end-1)*1e9, cc.modely.face(1:end-1)*1e9, ...
                                                            sumN.TO.data(2:end-1, 2:end-1));
        writeDataToFile2D(['sum_' type '_ALL'], cc, cc.modelx.face(1:end-1)*1e9, cc.modely.face(1:end-1)*1e9, ...
                                                            sumN.ALL.data(2:end-1, 2:end-1));
        %>二维画图,无法画在同一画布
        sumN.ALL.plotField(cc, 'n')
        legend("ALL")
    end
    
end