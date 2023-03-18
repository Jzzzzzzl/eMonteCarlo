function computeDriftVwithEFieldSoft(obj, cc)
    %>计算不同电场下的漂移速度
    tic
    [m, ~] = size(cc.eFieldInput);
    obj.driftVField = zeros(m, 1);
    for i = 1 : m
        index = find(cc.time.face >= cc.eFieldInput(i, 1), 1) - 1;
        if index <= 0
            index = 1;
        end
        if isempty(index)
            index = cc.Nt;
        end
        if m ~= 1
            obj.driftVField(i) = obj.driftVTime(index);
        else
            obj.driftVField = obj.driftVTime(index);
        end
    end
    disp(['漂移速度随电场变化关系计算完成！耗时：', sprintf('%.2f', toc), ' s'])
end