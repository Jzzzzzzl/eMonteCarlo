function extractPhononHistoryInformation(obj, fileID, cc)
    %>提取声子历史信息
    tic
    obj.positions = zeros(1, 3, cc.superElecs * cc.noFly);
    obj.vectors = zeros(1, 3, cc.superElecs * cc.noFly);
    obj.frequencys = zeros(cc.superElecs * cc.noFly, 1);
    obj.times = zeros(cc.superElecs * cc.noFly, 1);
    obj.aborems = zeros(cc.superElecs * cc.noFly, 1);
    obj.polars = zeros(cc.superElecs * cc.noFly, 1);
    
    pIndex = 0;
    while ~feof(fileID)
        pIndex = pIndex + 1;
        strline = fgetl(fileID);
        dataline = textscan(strline, '%f %f %f %f %f %f %f %f %s %s');
        obj.positions(:, :, pIndex) = deal(dataline{1}(1:3)');
        obj.vectors(:, :, pIndex) = deal(dataline{1}(4:6)');
        obj.frequencys(pIndex) = deal(dataline{1}(7)');
        obj.times(pIndex) = deal(dataline{1}(8)');
        obj.aborems(pIndex) = deal(dataline{1}(9)');
        obj.polars(pIndex) = deal(dataline{1}(10)');
    end
    fclose(fileID);
    disp(['声子历史数据提取完成！耗时：', sprintf('%.2f', toc), ' s'])
end