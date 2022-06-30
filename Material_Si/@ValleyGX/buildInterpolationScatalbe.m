function buildInterpolationScatalbe(obj, cc, pc, sc)
    %>构造散射率插值表
    es = ElectricStatus;
    es.time = 0;
    es.valley = 1;
    es.position = [0 0 0];
    cc.computePositionParameters(es);
    obj.interScatable = zeros(obj.nofScat, cc.NE+1);
    for i = 1 : cc.NE+1
        es.energy = cc.energy.face(i) + obj.Eg;
        k = obj.generateStandardElectricWaveVector(es, pc, randNumber(0, pi));
        es = obj.getGeneralElectricWaveVector(es, pc, k);
        es = obj.computeEnergyAndGroupVelocity(es, pc);
        obj.scatteringTable(es, sc, pc);
        obj.interScatable(:, i) = obj.scatTableAll;
    end
end