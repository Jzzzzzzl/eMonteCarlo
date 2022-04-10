function electricVelocityPlot(obj, pc)
    %>电子速度画图
    num = 100;
    velocityGK = zeros(num, 2);
    tempk = linspace(0.01, 0.99, num);
    es = ElectricStatus;
    for i = 1 : num
        es.vector = tempk(i) * pc.hsp.K;
        es.valley = 11;
        es.valley = obj.whichValley(es);
        es = obj.computeEnergyAndGroupVelocity(es, pc);
        velocityGK(i, 1) = tempk(i);
        velocityGK(i, 2) = es.velocity(2);
    end
    figure
    plot(velocityGK(:,1), velocityGK(:,2))
    xlabel("k/dGK")
    ylabel("Velocity/(m/s)")
end