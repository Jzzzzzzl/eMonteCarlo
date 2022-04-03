function electricVelocityPlot(obj, num, pc)
    %>电子速度画图
    velocityGX = zeros(num, 2);
    tempk = linspace(0.01, 1, num);
    es = ElectricStatus;
    for i = 1 : num
        es.vector = [tempk(i) 0 0] * pc.dGX;
        es.valley = DecideValleyKind.whichValley(es);
        es = obj.computeEnergyAndVelocity(es, pc);
        velocityGX(i, 1) = es.vector(1) / pc.dGX;
        velocityGX(i, 2) = es.velocity(1);
    end
    figure
    plot(velocityGX(:,1),velocityGX(:,2))
    xlabel("k/dGX")
    ylabel("Velocity/(m/s)")
end