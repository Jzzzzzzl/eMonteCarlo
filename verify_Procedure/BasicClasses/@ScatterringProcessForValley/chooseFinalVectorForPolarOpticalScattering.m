function [es, ps] = chooseFinalVectorForPolarOpticalScattering(~, es, ps, dv, sc, pc, frequency, flag)
    %>极化光学散射后选择电子波矢
    item = 1;
    error = 1;
    maxitem = 20;
    allowedError = 0.2;
    
    if flag == 1
        theta = dv.sr.thetaPOab(frequency);
    else
        theta = dv.sr.thetaPOem(frequency);
    end
    
    agoVector = es.vector;
    phononEnergy = double(pc.hbar * frequency);
    es.energy = es.energy + flag * phononEnergy;
    while error > allowedError && item < maxitem
        es = dv.bs.chooseElectricWaveVector(es, pc, theta);
        ps.vector = es.vector - agoVector;
        ps = dv.bs.phononWhetherBeyondBZone(ps, pc);
        ps.getFrequency(sc);
        error = abs((ps.energy - phononEnergy) / ps.energy);
        item = item + 1;
    end
    es = dv.bs.computeEnergyAndGroupVelocity(es, pc);
end