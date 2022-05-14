function extractPhononHistoryInformation(obj, fileID, cc)
    %>提取声子历史信息
    tic
%     obj.positions = zeros(1, 3, cc.superElecs * cc.noFly);
%     obj.vectors = zeros(1, 3, cc.superElecs * cc.noFly);
    obj.xpositions = zeros(cc.superElecs * cc.noFly, 1);
    obj.ypositions = zeros(cc.superElecs * cc.noFly, 1);
    obj.frequencys = zeros(cc.superElecs * cc.noFly, 1);
    obj.times = zeros(cc.superElecs * cc.noFly, 1);
    obj.aborems = string(zeros(cc.superElecs * cc.noFly, 1));
    obj.polars = string(zeros(cc.superElecs * cc.noFly, 1));
    
    pIndex = 0;
    while ~feof(fileID)
        strline = fgetl(fileID);
        dataline = textscan(strline, '%f %f %f %f %f %f %f %f %s %s');
        if ~isequal(dataline{10}, "non")
            pIndex = pIndex + 1;
            obj.xpositions(pIndex) = dataline{1};
            obj.ypositions(pIndex) = dataline{2};
            obj.frequencys(pIndex) = dataline{7};
            obj.times(pIndex) = dataline{8};
            obj.aborems(pIndex) = dataline{9};
            obj.polars(pIndex) = dataline{10};
        end
    end
    fclose(fileID);
    disp(['声子历史数据提取完成！耗时：', sprintf('%.2f', toc), ' s'])
end