function initializeElectricStatus(es, dv, pc, cc)
    %>电子初始化
    es.valley = cc.initValley;
    es.position(1) = randNumber(cc.modelx.face(1), cc.dSource);
    es.position(2) = randNumber(cc.modely.face(end-1), cc.modely.face(end));
    es.position(3) = 0;
    es.charge = cc.superElecCharge;
    dv.valleyGuidingPrinciple(es);
    es.energy = maxwellDistribution(pc, cc) + dv.valley.Eg;
    k = dv.valley.generateStandardElectricWaveVector(es, pc, randNumber(0, pi));
    es = dv.valley.getGeneralElectricWaveVector(es, pc, k);
    es = dv.valley.computeEnergyAndGroupVelocity(es, pc);
end