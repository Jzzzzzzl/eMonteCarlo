function computeValleyOccupationWithElectricField(obj, cc)
    %>能谷占据率随阶跃场强变化
    if isempty(obj.occTime)
        error("请先计算能谷占据率随时间变化关系！")
    end
    [m, ~] = size(cc.eFieldInput);
    obj.occField = zeros(m, 3);
    for i = 1 : m
        index = find(cc.time.face >= cc.eFieldInput(i, 1), 1) - 1;
        if index <= 0
            index = 1;
        end
        if isempty(index)
            index = cc.Nt;
        end
        obj.occField(i, :) = obj.occTime(index, :);
    end
    figure
    hold on
    [~, n] = size(obj.occField);
    for i = 1 : n
        slg = semilogx(abs(cc.eFieldInput(:, 2)), obj.occField(:, i), '-*');
        slg.LineWidth = 2;
    end
    xlabel("V/m"); ylabel(".a.u");
    legend('U', 'Gamma1', 'Gamma3')
    title("valley occupation")
    hold off
end