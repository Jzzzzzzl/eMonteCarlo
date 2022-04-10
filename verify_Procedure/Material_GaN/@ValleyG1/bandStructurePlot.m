function bandStructurePlot(obj, pc)
    %>电子能带画图
    num = 100;
    energyGK = zeros(num, 2);
    tempk = linspace(0.01, 0.99, num);
    es = ElectricStatus;
    for i = 1 : num
        es.vector = tempk(i) * pc.hsp.K;
        es.valley = 11;
        es.valley = obj.whichValley(es);
        es = obj.computeEnergyAndGroupVelocity(es, pc);
        energyGK(i, 1) = tempk(i);
        energyGK(i, 2) = es.energy / pc.e;
    end
    figure
    plot(energyGK(:,1), energyGK(:,2))
    xlabel("k/dGK")
    ylabel("Energy/(eV)")

end