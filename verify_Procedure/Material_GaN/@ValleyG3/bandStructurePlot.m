function bandStructurePlot(obj, pc)
    %>电子能带画图
    num = 100;
    energyGM = zeros(num, 2);
    tempk = linspace(0.01, 0.99, num);
    es = ElectricStatus;
    for i = 1 : num
        es.vector = tempk(i) * pc.hsp.M;
        es.valley = 13;
        es.valley = EPWaveVectorModify.whichValley(es);
        es = obj.computeEnergyAndGroupVelocity(es, pc);
        energyGM(i, 1) = tempk(i);
        energyGM(i, 2) = es.energy / pc.e;
    end
    figure
    plot(energyGM(:,1), energyGM(:,2))
    xlabel("k/dGM")
    ylabel("Energy/(eV)")

end