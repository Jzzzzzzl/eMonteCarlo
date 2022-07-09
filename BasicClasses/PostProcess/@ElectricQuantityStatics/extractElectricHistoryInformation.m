function extractElectricHistoryInformation(obj, cc, N)
    %>提取电子历史信息
    tic
    cc.timeGrid(obj.minTime, obj.maxTime, N);
    cc.energyGrid(0, obj.maxEnergy, N);
    %>临时变量
    aveepos = zeros(cc.NX, cc.NY);
    aveepcou = ones(cc.NX, cc.NY);
    aveetime = zeros(cc.Nt, 1);
    aveetcou = ones(cc.Nt, 1);
    avedtime = zeros(cc.Nt, 1);
    avedtcou = ones(cc.Nt, 1);
    valleytime = zeros(cc.Nt, 3);
    enums = zeros(cc.NE, 1);
    scatnums = zeros(30, 3);
    idflag = 0;
    tflag = 0;
    
    startMatlabPool(cc.localWorkers);
    path = cc.filePath;
    spmd
        filename = [path 'ElectronLogPart' num2str(labindex)];
        fileID = fopen(filename);
        while ~feof(fileID)
            strline = fgetl(fileID);
            dataline = textscan(strline, '%d %f %f %f %f %f %f %d %d');
            %>查找所在区域坐标
            if dataline{6} >= obj.minTime && dataline{6} <= obj.maxTime
                i = find(cc.modelx.face >= dataline{2}, 1) - 1;
                if cc.NY ~= 1
                    j = find(cc.modely.face >= dataline{3}, 1) - 1;
                else
                    j = 1;
                end
                t = find(cc.time.face >= dataline{6}, 1) - 1;
                e = find(cc.energy.face >= dataline{5}, 1) - 1;
            else
                continue;
            end
            if isempty(i*j*t*e) || (i*j*t*e) == 0
                continue;
            end
            %>平均能量随位置变化
            aveepos(i, j) = aveepos(i, j) + dataline{5};
            aveepcou(i, j) = aveepcou(i, j) + 1;
            %>平均能量随时间变化
            aveetime(t) = aveetime(t) + dataline{5};
            aveetcou(t) = aveetcou(t) + 1;
            %>平均漂移速度随时间变化
            avedtime(t) = avedtime(t) + dataline{7};
            avedtcou(t) = avedtcou(t) + 1;
            %>能谷占据率随时间变化
            absValley = abs(dataline{8});
            if dataline{1} ~= idflag || t ~= tflag
                tflag = t;
                idflag = dataline{1};
                if absValley <= 6%>Si GX/GaN U
                    valleytime(t, 1) = valleytime(t, 1) + 1;
                elseif absValley == 11%>GaN G1
                    valleytime(t, 2) = valleytime(t, 2) + 1;
                elseif absValley == 13%>GaN G3
                    valleytime(t, 3) = valleytime(t, 3) + 1;
                end
            end
            %>能量历史分布统计
            enums(e) = enums(e) + 1;
            %>散射类型统计
            s = dataline{9};
            if absValley <= 6%>Si GX/GaN U
                scatnums(s, 1) = scatnums(s, 1) + 1;
            elseif absValley == 11%>GaN G1
                scatnums(s, 2) = scatnums(s, 2) + 1;
            elseif absValley == 13%>GaN G3
                scatnums(s, 3) = scatnums(s, 3) + 1;
            end
        end
        aveepos = aveepos ./ aveepcou;
        aveetime = aveetime ./ aveetcou;
        avedtime = avedtime ./ avedtcou;
        fclose(fileID);
    end
    
    for i = 2 : cc.localWorkers
        aveepos{1} = aveepos{1} + aveepos{i};
        aveetime{1} = aveetime{1} + aveetime{i};
        avedtime{1} = avedtime{1} + avedtime{i};
        valleytime{1} = valleytime{1} + valleytime{i};
        scatnums{1} = scatnums{1} + scatnums{i};
        enums{1} = enums{1} + enums{i};
    end
    obj.aveEPos = aveepos{1} ./ cc.localWorkers;
    obj.aveETime = aveetime{1} ./ cc.localWorkers;
    obj.driftVTime = avedtime{1} ./ cc.localWorkers;
    obj.occTime = valleytime{1};
    obj.eNums = enums{1};
    obj.scatNums = scatnums{1};
    disp(['电子历史数据提取完成！耗时：', sprintf('%.2f', toc), ' s'])
end