function electricVelocityPlot(obj, pc, pointA, pointB)
    %>电子速度画图
    num = 100;
    velocityAB = zeros(num, 2);
    tempk = linspace(0.01, 0.99, num);
    es = ElectricStatus;
    vectorAB = pointB - pointA;
    for i = 1 : num
        es.vector = tempk(i) * vectorAB + pointA;
        es.valley = 1;
        es.valley = EPWaveVectorModify.whichValley(es);
        es = obj.computeEnergyAndGroupVelocity(es, pc);
        velocityAB(i, 1) = tempk(i);
        velocityAB(i, 2) = es.velocity(2);
    end
    figure
    plot(velocityAB(:,1), velocityAB(:,2))
    xlabel(".a.u")
    ylabel("Velocity/(m/s)")
end