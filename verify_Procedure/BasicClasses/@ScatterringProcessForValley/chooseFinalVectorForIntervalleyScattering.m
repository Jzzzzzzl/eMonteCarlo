function [es, ps] = chooseFinalVectorForIntervalleyScattering(~, es, ps, dv, sc, pc, frequency, flag)
    %>选择谷间散射末态电子和声子状态（非弹性）
    item = 1;
    eError = 1;
    maxitem = 20;
    allowedError = 0.2;
    
    agoVector = es.vector;
    phononEnergy = double(pc.hbar * frequency);
    es.energy = es.energy + flag * phononEnergy;
    while eError > allowedError && item < maxitem
        es = dv.bs.chooseElectricWaveVector(es, pc, randNumber(0, pi));
        ps.vector = es.vector - agoVector;
        ps = dv.bs.phononWhetherBeyondBZone(ps, pc);
        ps.getFrequency(sc);
        eError = abs((ps.energy - phononEnergy) / ps.energy);
        item = item + 1;
    end
    es = dv.bs.computeEnergyAndGroupVelocity(es, pc);
    if ~isreal(es.vector(1))
        disp(es)
        error("出现虚数！")
    end
end