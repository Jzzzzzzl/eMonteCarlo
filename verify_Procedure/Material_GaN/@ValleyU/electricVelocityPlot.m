function electricVelocityPlot(obj, pc)
    %>电子速度画图
    num = 100;
    velocityLM = zeros(num, 2);
    tempk = linspace(0.01, 0.99, num);
    es = ElectricStatus;
    vectorLM = pc.hsp.M - pc.hsp.L;
    for i = 1 : num
        es.vector = tempk(i) * vectorLM + pc.hsp.L;
        es.valley = 1;
        es.valley = EPWaveVectorModify.whichValley(es);
        es = obj.computeEnergyAndGroupVelocity(es, pc);
        velocityLM(i, 1) = tempk(i);
        velocityLM(i, 2) = es.velocity(3);
    end
    figure
    plot(velocityLM(:,1), velocityLM(:,2))
    xlabel("k/dLM")
    ylabel("Velocity/(m/s)")
end