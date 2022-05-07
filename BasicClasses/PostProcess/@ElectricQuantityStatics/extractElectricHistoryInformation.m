function extractElectricHistoryInformation(obj, sh, cc)
    %>提取电子历史信息
    tic
    positionsTemp = zeros(1, 3, cc.superElecs, cc.noFly);
    vectorsTemp = zeros(1, 3, cc.superElecs, cc.noFly);
    energysTemp = zeros(cc.superElecs, cc.noFly);
    timesTemp = zeros(cc.superElecs, cc.noFly);
    perdriftsTemp = zeros(cc.superElecs, cc.noFly);
    valleysTemp = zeros(cc.superElecs, cc.noFly);
    scatypesTemp = zeros(cc.superElecs, cc.noFly);
    for i = 1 : cc.superElecs
        for j = 1 : cc.noFly
            positionsTemp(:, :, i, j) = sh.eHistory(i, j).position;
            vectorsTemp(:, :, i, j) = sh.eHistory(i, j).vector;
        end
        energysTemp(i, :) = [sh.eHistory(i, :).energy];
        timesTemp(i, :) = [sh.eHistory(i, :).time];
        perdriftsTemp(i, :) = [sh.eHistory(i, :).perdrift];
        valleysTemp(i, :) = [sh.eHistory(i, :).valley];
        scatypesTemp(i, :) = [sh.eHistory(i, :).scatype];
    end
    obj.positions = positionsTemp;
    obj.vectors = vectorsTemp;
    obj.energys = energysTemp;
    obj.times = timesTemp;
    obj.perdrifts = perdriftsTemp;
    obj.valleys = valleysTemp;
    obj.scatypes = scatypesTemp;
    disp(['数据提取完成！耗时：', sprintf('%.2f', toc), ' s'])
end