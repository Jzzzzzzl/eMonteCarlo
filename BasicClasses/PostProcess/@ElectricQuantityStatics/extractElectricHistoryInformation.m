function extractElectricHistoryInformation(obj, fileID, cc)
    %>提取电子历史信息
    tic
    obj.positions = zeros(1, 3, cc.superElecs, cc.noFly);
    obj.vectors = zeros(1, 3, cc.superElecs, cc.noFly);
    obj.energys = zeros(cc.superElecs, cc.noFly);
    obj.times = zeros(cc.superElecs, cc.noFly);
    obj.perdrifts = zeros(cc.superElecs, cc.noFly);
    obj.valleys = zeros(cc.superElecs, cc.noFly);
    obj.scatypes = zeros(cc.superElecs, cc.noFly);
    
    eIndex = 0;
    flyIndex = 1;
    while ~feof(fileID)
        eIndex = eIndex + 1;
        if eIndex > cc.superElecs
            eIndex = 1;
            flyIndex = flyIndex + 1;
        end
        strline = fgetl(fileID);
        dataline = textscan(strline, '%f');
        obj.positions(:, :, eIndex, flyIndex) = deal(dataline{1}(1:3)');
        obj.vectors(:, :, eIndex, flyIndex) = deal(dataline{1}(4:6)');
        obj.energys(eIndex, flyIndex) = deal(dataline{1}(7)');
        obj.times(eIndex, flyIndex) = deal(dataline{1}(8)');
        obj.perdrifts(eIndex, flyIndex) = deal(dataline{1}(9)');
        obj.valleys(eIndex, flyIndex) = deal(dataline{1}(10)');
        obj.scatypes(eIndex, flyIndex) = deal(dataline{1}(11)');
    end
    fclose(fileID);
    disp(['数据提取完成！耗时：', sprintf('%.2f', toc), ' s'])
end