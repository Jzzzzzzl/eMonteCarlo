function statisticPhonon(obj, mm)
    % 网格划分
    mm.frequencyGrid(obj.minFrequency, obj.maxFrequency, obj.NW);
    % index0用于筛选吸收类型声子
    index0 = obj.aborems == "ab";
    % index1用于筛选发射类型声子
    index1 = obj.aborems == "em";
    for k = 1 : obj.NW
        % index2用于筛选频率范围
        index2 = obj.frequencys > mm.frequency.face(k) & obj.frequencys < mm.frequency.face(k + 1);

        % LA统计
        index3 = obj.polars == "LA";
        indexab = index0 & index2 & index3;
        indexem = index1 & index2 & index3;
        % pop中存储单个频率段对应的声子群在sh.pHistory中的标号
        obj.phLAab(k).pop = find(indexab);
        obj.phLAem(k).pop = find(indexem);
        % num中存储单个频率段对应的声子数目
        obj.phLAab(k).num = length(obj.phLAab(k).pop);
        obj.phLAem(k).num = length(obj.phLAem(k).pop);

        % TA统计
        index3 = obj.polars == "TA";
        indexab = index0 & index2 & index3;
        indexem = index1 & index2 & index3;
        obj.phTAab(k).pop = find(indexab);
        obj.phTAem(k).pop = find(indexem);
        obj.phTAab(k).num = length(obj.phTAab(k).pop);
        obj.phTAem(k).num = length(obj.phTAem(k).pop);

        % LO统计
        index3 = obj.polars == "LO";
        indexab = index0 & index2 & index3;
        indexem = index1 & index2 & index3;
        obj.phLOab(k).pop = find(indexab);
        obj.phLOem(k).pop = find(indexem);
        obj.phLOab(k).num = length(obj.phLOab(k).pop);
        obj.phLOem(k).num = length(obj.phLOem(k).pop);

        % TO统计
        index3 = obj.polars == "TO";
        indexab = index0 & index2 & index3;
        indexem = index1 & index2 & index3;
        obj.phTOab(k).pop = find(indexab);
        obj.phTOem(k).pop = find(indexem);
        obj.phTOab(k).num = length(obj.phTOab(k).pop);
        obj.phTOem(k).num = length(obj.phTOem(k).pop);

        % 所有极化支
        index3 = obj.polars ~= "non";
        indexab = index0 & index2 & index3;
        indexem = index1 & index2 & index3;
        obj.phALLab(k).pop = find(indexab);
        obj.phALLem(k).pop = find(indexem);
        obj.phALLab(k).num = length(obj.phALLab(k).pop);
        obj.phALLem(k).num = length(obj.phALLem(k).pop);
    end
end