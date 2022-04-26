function waveVectorDistribution(obj, sh, pc, cc, time)
    %>
    cc.waveVectorGrid(-1.5*pc.dBD, 1.5*pc.dBD, 30);
    qVector = zeros(cc.superElecs, 1);
    qNumbers = zeros(cc.NQ, 2);
    legends = string(zeros(time(3) + 1, 1));
    figure
    hold on
    for j = 1 : time(3) + 1
        Time = (time(2) - time(1)) * (j - 1) / time(3) + time(1);
        if Time > obj.minimumTime
            error("超出了最小时间！")
        end
        for i = 1 : cc.superElecs
            times = deal([sh.eHistory(i, :).time]);
            index = find(times >= Time, 1) - 1;
            if index == 0
                index = 1;
            end
            qVector(i) = sh.eHistory(i, index).vector(1);
        end
        for k = 1 : cc.NQ
            index = qVector >= cc.vector.face(k) & qVector <= cc.vector.face(k+1);
            qNumbers(k, 1) = cc.vector.point(k+1);
            qNumbers(k, 2) = sum(double(index));
        end
        slg = plot(qNumbers(:, 1), qNumbers(:, 2));
        slg.LineWidth = 2;
        legends(j) = num2str(Time*1e12);
    end
    xlabel("k/1/m");ylabel(".a.u");
    legend(legends)
end