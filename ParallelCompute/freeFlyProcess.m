function [es] = freeFlyProcess(es, dv, pc, cc)
    %% 自由飞行过程
    energyTemp = es.energy;
    vectorTemp = es.vector;
    
    dv.valleyGuidingPrinciple(es);
    dv.valley.computeFlyTime(es);
    es.time = es.time + dv.valley.flyTime;
    eField = cc.computeElectricField(es);
    es.vector = es.vector + (-pc.e) * eField * dv.valley.flyTime / pc.hbar;
    es = dv.valley.modifyElectricWaveVector(es, pc);
    es = dv.valley.computeEnergyAndGroupVelocity(es, pc);
    rAgo = es.position;
    es.position = es.position + es.velocity * dv.valley.flyTime;
    bool = cc.boundaryReflection(rAgo, es);
    if bool; initializeElectricStatus(es, dv, pc, cc); end
    
    vectorMold = sqrt(sum((vectorTemp - es.vector).^2));
    es.perdrift = (es.energy - energyTemp) / (pc.hbar * vectorMold);
end