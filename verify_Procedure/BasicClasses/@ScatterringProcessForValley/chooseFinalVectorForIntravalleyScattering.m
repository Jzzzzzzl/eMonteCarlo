function [es] = chooseFinalVectorForIntravalleyScattering(~, es, ps, dv, sc, pc, frequency, flag)
    %>谷内散射后选择电子波矢和声子状态
    item = 1;
    error = 1;
    maxitem = 20;
    allowedError = 0.1;
    
    agoVector = es.vector;
    phononEnergy = double(pc.hbar * frequency);
    es.energy = es.energy + flag * phononEnergy;
    while error > allowedError && item < maxitem
        es = dv.bs.chooseWaveVector(es, pc, randNumber(0, pi));
        ps.vector = es.vector - agoVector;
        ps = dv.bs.phononWhetherBeyondBZone(ps, pc);
        ps.getFrequency(sc);
        error = abs((ps.energy - phononEnergy) / ps.energy);
        item = item + 1;
    end
end