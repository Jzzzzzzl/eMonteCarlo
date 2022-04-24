function electricVelocityPlot(obj, pc, pointA, pointB)
    %>电子速度画图
    num = 100;
    velocityGM = zeros(num, 2);
    tempk = linspace(0.01, 0.99, num);
    es = ElectricStatus;
    vectorAB = pointB - pointA;
    for i = 1 : num
        es.vector = tempk(i) * vectorAB + pointA;
        es.valley = 13;
        es.valley = EPWaveVectorModify.whichValley(es);
        es = obj.computeEnergyAndGroupVelocity(es, pc);
        velocityGM(i, 1) = tempk(i);
        velocityGM(i, 2) = es.velocity(1);
    end
    figure
    plot(velocityGM(:,1), velocityGM(:,2))
    xlabel(".a.u")
    ylabel("Velocity/(m/s)")
end