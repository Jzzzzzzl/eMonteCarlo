function computeTerminalCurrent(obj, cc)
    %>计算端电流
    outEles = zeros(cc.Nt, 1);
    for i = 1 : cc.superElecs
        xPositions = squeeze(obj.positions(:, 1, i, 2:end));
        index = xPositions == cc.modelx.face(1);
        timeEles = obj.times(i, index);
        if ~isempty(timeEles)
            for k = 1 : length(timeEles)
                index1 = find(cc.time.face > timeEles(k), 1) - 1;
                outEles(index1) = outEles(index1) + 1;
            end
        end
    end
    obj.current = zeros(cc.Nt, 2);
    for i = 1 : cc.Nt
        deltat = cc.time.face(i+1) - cc.time.face(i);
        obj.current(i, 1) = cc.time.point(i+1)*1e12;
        obj.current(i, 2) = cc.superElecCharge*outEles(i)/deltat;
    end
    figure
    plot(obj.current(:, 1), obj.current(:, 2))
end