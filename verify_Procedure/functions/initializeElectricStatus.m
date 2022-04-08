function [es] = initializeElectricStatus(es, dv, pc, cc)
    %>电子初始化
    es.valley = 11;
    es.position = [0 0 0];
    dv.valleyGuidingPrinciple(es);
    es.energy = maxwellDistribution(pc, cc) + dv.valley.Eg;
    k = dv.valley.generateStandardElectricWaveVector(es, pc, randNumber(0, pi));
    es = dv.valley.getGeneralElectricWaveVector(es, pc, k);
    es = dv.valley.computeEnergyAndGroupVelocity(es, pc);
end