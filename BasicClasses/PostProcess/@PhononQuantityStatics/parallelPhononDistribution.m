function parallelPhononDistribution(obj, cc)
    %>并行处理声子Log文件
    tic
    p = parpool(cc.localWorkers);
    spmd
        path = '/home/jiang/documents/eMdatas/epDatas/';
        filename = [path 'PhononLogPart' num2str(labindex)];
        fileID = fopen(filename);
        sumF = zeros(cc.NX, cc.NY, 4, cc.NW);
        while ~feof(fileID)
            strline = fgetl(fileID);
            dataline = textscan(strline, '%f %f %f %f %f %f %f %f %s %s');
            if dataline{8} <= obj.minimumTime
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
                            sumF(i, j, 1, k) = sumF(i, j, 1, k) - dataline{7};
                        case 'TA'
                            sumF(i, j, 2, k) = sumF(i, j, 2, k) - dataline{7};
                        case 'LO'
                            sumF(i, j, 3, k) = sumF(i, j, 3, k) - dataline{7};
                        case 'TO'
                            sumF(i, j, 4, k) = sumF(i, j, 4, k) - dataline{7};
                    end
                case 'em'
                    switch string(dataline{10})
                        case 'LA'
                            sumF(i, j, 1, k) = sumF(i, j, 1, k) + dataline{7};
                        case 'TA'
                            sumF(i, j, 2, k) = sumF(i, j, 2, k) + dataline{7};
                        case 'LO'
                            sumF(i, j, 3, k) = sumF(i, j, 3, k) + dataline{7};
                        case 'TO'
                            sumF(i, j, 4, k) = sumF(i, j, 4, k) + dataline{7};
                    end
            end
        end
        fclose(fileID);
    end
    obj.allSumF = sumF{1};
    for i = 2 : cc.localWorkers
        obj.allSumF = obj.allSumF + sumF{i};
    end
    delete(p)
    disp(['声子历史数据处理结束！耗时：', sprintf('%.2f', toc), ' s'])
end