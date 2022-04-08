function bandStructurePlot(obj, pc)
    %>电子能带画图
    num = 100;
    energyLM = zeros(num, 2);
    tempk = linspace(0.01, 0.99, num);
    es = ElectricStatus;
    vectorLM = pc.hsp.M - pc.hsp.L;
    for i = 1 : num
        es.vector = tempk(i) * vectorLM + pc.hsp.L;
        es.valley = 1;
        es.valley = DecideValleyKind.whichValley(es);
        es = obj.computeEnergyAndGroupVelocity(es, pc);
        energyLM(i, 1) = tempk(i);
        energyLM(i, 2) = es.energy / pc.e;
    end
    figure
    plot(energyLM(:,1), energyLM(:,2))
    xlabel("k/dLM")
    ylabel("Energy/(eV)")
end