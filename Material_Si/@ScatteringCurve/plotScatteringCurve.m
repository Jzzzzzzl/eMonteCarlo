function plotScatteringCurve(obj, pc)
    %>散射曲线作图
    num = 100;
    kPath = linspace(0, pc.dBD, num);
    ps = PhononStatus;
    frequency = zeros(num, 4);
    for i = 1 : num
        ps.vector = [kPath(i) 0 0];
        ps.polar = 'LA';
        frequency(i, 1) = obj.phononFrequency(ps);
        ps.polar = 'TA';
        frequency(i, 2) = obj.phononFrequency(ps);
        ps.polar = 'LO';
        frequency(i, 3) = obj.phononFrequency(ps);
        ps.polar = 'TO';
        frequency(i, 4) = obj.phononFrequency(ps);
    end
    figure
    hold on
    for i = 1 : 4
        plot(kPath, frequency(:, i), 'LineWidth', 2)
    end
    title("Si Scattering Curve")
    xlabel("q path"); ylabel("Omega [Hz]")
    legend("LA", "TA", "LO", "TO")
end