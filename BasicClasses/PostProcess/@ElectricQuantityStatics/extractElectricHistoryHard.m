function extractElectricHistoryHard(obj, cc, N, kinput)
    %>提取电子历史信息
    %>起始于kinput，但不包括kinput
    tic
    cc.timeGrid(obj.minTime, obj.maxTime, N);
    
    nums = cc.noFly - kinput;
    positions = zeros(1, 3, cc.superElecs, nums);
    vectors = zeros(1, 3, cc.superElecs, nums);
    energys = zeros(cc.superElecs, nums);
    times = zeros(cc.superElecs, nums);
%     perdrifts = zeros(cc.superElecs, nums);
%     valleys = zeros(cc.superElecs, nums);
%     scatypes = zeros(cc.superElecs, nums);
    
    startMatlabPool(cc.localWorkers);
    path = cc.filePath;
    spmd
        filename = [path 'ElectronLogPart' num2str(labindex)];
        fileID = fopen(filename);
        while ~feof(fileID)
            strline = fgetl(fileID);
            dataline = textscan(strline, '%d %d %f %f %f %f %f %f %f %f %f %d %d');
            eIndex = dataline{1};
            flyIndex = dataline{2};
            if flyIndex > kinput
                positions(:, :, eIndex, flyIndex-kinput) = [dataline{3} dataline{4} dataline{5}];
                vectors(:, :, eIndex, flyIndex-kinput) = [dataline{6} dataline{7} dataline{8}];
                energys(eIndex, flyIndex-kinput) = dataline{9};
                times(eIndex, flyIndex-kinput) = dataline{10};
%                 perdrifts(eIndex, flyIndex-kinput) = dataline{11};
%                 valleys(eIndex, flyIndex-kinput) = dataline{12};
%                 scatypes(eIndex, flyIndex-kinput) = dataline{13};
            end
        end
        fclose(fileID);
    end
    
    for i = 2 : cc.localWorkers
        positions{1} = positions{1} + positions{i};
        vectors{1} = vectors{1} + vectors{i};
        energys{1} = energys{1} + energys{i};
        times{1} = times{1} + times{i};
%         perdrifts{1} = perdrifts{1} + perdrifts{i};
%         valleys{1} = valleys{1} + valleys{i};
%         scatypes{1} = scatypes{1} + scatypes{i};
    end
    obj.positions = positions{1};
    obj.vectors = vectors{1};
    obj.energys = energys{1};
    obj.times = times{1};
%     obj.perdrifts = perdrifts{1};
%     obj.valleys = valleys{1};
%     obj.scatypes = scatypes{1};
    disp(['电子历史数据提取完成！耗时：', sprintf('%.2f', toc), ' s'])
end