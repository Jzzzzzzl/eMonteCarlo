function electricVelocityPlot(obj, pc)
    %>电子速度画图
    num = 100;
    velocityGX = zeros(num, 2);
    tempk = linspace(0.01, 1, num);
    es = ElectricStatus;
    for i = 1 : num
        es.vector = tempk(i) * pc.hsp.X;
        es.valley = DecideValleyKind.whichValley(es);
        es = obj.computeEnergyAndGroupVelocity(es, pc);
        velocityGX(i, 1) = tempk(i);
        velocityGX(i, 2) = es.velocity(2);
    end
    figure
    plot(velocityGX(:,1),velocityGX(:,2))
    xlabel("k/dGX")
    ylabel("Velocity/(m/s)")
end