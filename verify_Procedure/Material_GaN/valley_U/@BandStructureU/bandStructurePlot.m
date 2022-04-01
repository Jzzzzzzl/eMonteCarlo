function bandStructurePlot(obj, num, pc)
    %>电子能带画图
    energyGL = zeros(num, 2);
    tempk = linspace(0.01, 0.1, num);
    es = ElectricStatus;
    for i = 1 : num
        es.vector = [tempk(i) 0.01 0.01] * pc.dGL;
        es.valley = 1;
        es.valley = DecideValleyKind.whichValley(es);
        es = obj.computeEnergyAndVelocity(es, pc);
        energyGL(i, 1) = es.vector(1) / pc.dGL;
        energyGL(i, 2) = es.energy / pc.e;
    end
    figure
    plot(energyGL(:,1), energyGL(:,2))
    xlabel("k/dGL")
    ylabel("Energy/(eV)")

end