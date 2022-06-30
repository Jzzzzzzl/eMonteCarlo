function plotScatteringCurve(obj, pc)
    %>散射曲线作图
    num = 100;
    kPath = linspace(0, pc.dBD, num);
    ps = PhononStatus;
    frequency = zeros(num, 4);
    for i = 1 : num
        ps.vector = [kPath(i) 0 0];
        ps.polar = 1;
        frequency(i, 1) = obj.phononFrequency(ps);
        ps.polar = 2;
        frequency(i, 2) = obj.phononFrequency(ps);
        ps.polar = 3;
        frequency(i, 3) = obj.phononFrequency(ps);
        ps.polar = 4;
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