function computeTerminalCurrent(obj, cc)
    %>计算端电流
    tic
    outEles = zeros(cc.Nt, 1);
    for i = 1 : cc.superElecs
        xPositions = squeeze(obj.positions(:, 1, i, 2:end));
        index = xPositions >= cc.initPosition(1);
        timeEles = obj.times(i, index);
        if ~isempty(timeEles)
            for k = 1 : length(timeEles)
                index1 = find(cc.time.face > timeEles(k), 1) - 1;
                outEles(index1) = outEles(index1) + 1;
            end
        end
    end
    obj.curTime = zeros(cc.Nt, 2);
    for i = 1 : cc.Nt
        deltat = cc.time.face(i+1) - cc.time.face(i);
        obj.curTime(i, 1) = cc.time.point(i+1)*1e12;
        obj.curTime(i, 2) = cc.superElecCharge*outEles(i)/deltat;
    end
    disp(['端电流随时间变化计算完成！耗时： ', sprintf('%.2f', toc), ' s']);
    figure
    plot(obj.curTime(:, 1), obj.curTime(:, 2))
end