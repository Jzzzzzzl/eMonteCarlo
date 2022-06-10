function parallelPhononDistribution(obj, cc)
    %>并行处理声子Log文件
    tic
    startMatlabPool(cc.localWorkers);
    path = cc.filePath;
    spmd
        filename = [path 'PhononLogPart' num2str(labindex)];
        fileID = fopen(filename);
        sumF = zeros(cc.NX, cc.NY, 4, cc.NW);
        sumN = zeros(cc.NX, cc.NY, cc.NW, 4, 2);
        while ~feof(fileID)
            strline = fgetl(fileID);
            dataline = textscan(strline, '%f %f %f %f %f %f %f %f %s %s');
            if dataline{8} >= obj.minTime && dataline{8} <= obj.maxTime
                i = find(cc.modelx.face >= dataline{1}, 1) - 1;
                j = find(cc.modely.face >= dataline{2}, 1) - 1;
                k = find(cc.frequency.face >= dataline{7}, 1) - 1;
            else
                continue;
            end
            if isempty(i*j*k) || i*j*k == 0
                continue;
            end
            switch string(dataline{9})
                case 'ab'
                    switch string(dataline{10})
                        case 'LA'
                            sumN(i, j, k, 1, 1) = sumN(i, j, k, 1, 1) + 1;
                            sumF(i, j, 1, k) = sumF(i, j, 1, k) - dataline{7};
                        case 'TA'
                            sumN(i, j, k, 2, 1) = sumN(i, j, k, 2, 1) + 1;
                            sumF(i, j, 2, k) = sumF(i, j, 2, k) - dataline{7};
                        case 'LO'
                            sumN(i, j, k, 3, 1) = sumN(i, j, k, 3, 1) + 1;
                            sumF(i, j, 3, k) = sumF(i, j, 3, k) - dataline{7};
                        case 'TO'
                            sumN(i, j, k, 4, 1) = sumN(i, j, k, 4, 1) + 1;
                            sumF(i, j, 4, k) = sumF(i, j, 4, k) - dataline{7};
                    end
                case 'em'
                    switch string(dataline{10})
                        case 'LA'
                            sumN(i, j, k, 1, 2) = sumN(i, j, k, 1, 2) + 1;
                            sumF(i, j, 1, k) = sumF(i, j, 1, k) + dataline{7};
                        case 'TA'
                            sumN(i, j, k, 2, 2) = sumN(i, j, k, 2, 2) + 1;
                            sumF(i, j, 2, k) = sumF(i, j, 2, k) + dataline{7};
                        case 'LO'
                            sumN(i, j, k, 3, 2) = sumN(i, j, k, 3, 2) + 1;
                            sumF(i, j, 3, k) = sumF(i, j, 3, k) + dataline{7};
                        case 'TO'
                            sumN(i, j, k, 4, 2) = sumN(i, j, k, 4, 2) + 1;
                            sumF(i, j, 4, k) = sumF(i, j, 4, k) + dataline{7};
                    end
            end
        end
        fclose(fileID);
    end
    obj.allSumF = sumF{1};
    obj.allSumN = sumN{1};
    for i = 2 : cc.localWorkers
        obj.allSumF = obj.allSumF + sumF{i};
        obj.allSumN = obj.allSumN + sumN{i};
    end
    disp(['声子历史数据处理结束！耗时：', sprintf('%.2f', toc), ' s'])
end