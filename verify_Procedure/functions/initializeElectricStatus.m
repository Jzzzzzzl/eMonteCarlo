function [es] = initializeElectricStatus(es, dv, pc, cc)
    %>电子初始化
    es.position = [0 0 0];
    es.energy = maxwellDistribution(pc, cc);
    es.valley = 1;
    dv.valleyGuidingPrinciple(es);
    es = dv.bs.chooseElectricWaveVector(es, pc, randNumber(0, pi));
    es = dv.bs.computeEnergyAndGroupVelocity(es, pc);
    disp(es)
end