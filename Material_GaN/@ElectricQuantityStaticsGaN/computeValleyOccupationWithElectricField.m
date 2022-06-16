function computeValleyOccupationWithElectricField(obj, cc)
    %>
    if isempty(obj.occTime)
        error("请先计算能谷占据率随时间变化关系！")
    end
    n = find(cc.eFieldInput(:, 1) >= obj.minTime, 1);
    obj.occField = zeros(n, 4);
    for i = 1 : n
        index = find(obj.occTime(:, 1) >= cc.eFieldInput(i, 1) * 1e12, 1) - 1;
        if isempty(index)
            [index, ~] = size(obj.occTime);
        end
        obj.occField(i, 1) = abs(cc.eFieldInput(i, 2));
        obj.occField(i, 2:end) = obj.occTime(index, 2:end);
    end
    figure
    hold on
    [~, n] = size(obj.occTime);
    for i = 2 : n
        slg = plot(obj.occField(:, 1), obj.occField(:, i), '-*');
        slg.LineWidth = 2;
    end
    xlabel("V/m"); ylabel(".a.u");
    legend('U', 'Gamma1', 'Gamma3')
    title("valley occupation")
    hold off
end