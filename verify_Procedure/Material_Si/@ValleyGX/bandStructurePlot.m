function bandStructurePlot(obj, pc)
    %>电子能带画图
    num = 100;
    energyGX = zeros(num, 2);
    tempk = linspace(0.01, 1, num);
    es = ElectricStatus;
    for i = 1 : num
        es.vector = tempk(i) * pc.hsp.X;
        es.valley = DecideValleyKind.whichValley(es);
        es = obj.computeEnergyAndGroupVelocity(es, pc);
        energyGX(i, 1) = tempk(i);
        energyGX(i, 2) = es.energy / pc.e;
    end
    figure
    plot(energyGX(:,1), energyGX(:,2))
    xlabel("k/dGX")
    ylabel("Energy/(eV)")
end