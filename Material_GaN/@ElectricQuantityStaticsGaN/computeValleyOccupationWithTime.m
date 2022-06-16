function computeValleyOccupationWithTime(obj, cc, N)
    %>能谷占据率随时间变化图
    cc.timeGrid(0, 0.999*obj.minTime, N);
    obj.occTime = zeros(cc.Nt, 4);
    for t = 1 : cc.Nt
        num = 0;
        numU = 0;
        numG1 = 0;
        numG3 = 0;
        for i = 1 : cc.superElecs
            index = find(cc.time.face(t) <= obj.times(i, :), 1) - 1;
            if isempty(index) || index == 0
                continue;
            end
            num = num + 1;
            absValley = abs(obj.valleys(i, index));
            if absValley <= 6
                numU = numU + 1;
            elseif absValley == 11
                numG1 = numG1 + 1;
            elseif absValley == 13
                numG3 = numG3 + 1;
            else
                error("能谷标号错误！")
            end
        end
        obj.occTime(t, 1) = cc.time.point(t + 1) * 1e12;
        if num ~= 0
            obj.occTime(t, 2) = numU / num;
            obj.occTime(t, 3) = numG1 / num;
            obj.occTime(t, 4) = numG3 / num;
        end
    end
    figure
    hold on
    n = size(obj.occTime);
    for i = 2 : n(2)
        slg = plot(obj.occTime(:, 1), obj.occTime(:, i));
        slg.LineWidth = 2;
    end
    xlabel("ps"); ylabel(".a.u");
    legend('U', 'Gamma1', 'Gamma3')
    title("valley occupation")
    hold off
end