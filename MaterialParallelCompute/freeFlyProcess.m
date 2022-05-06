function [es] = freeFlyProcess(es, dv, pc, cc)
    %% 自由飞行过程
    energyTemp = es.energy;
    vectorTemp = es.vector;
    
    dv.valleyGuidingPrinciple(es);
    dv.valley.computeFlyTime(es);
    es.time = es.time + dv.valley.flyTime;
    index = find(cc.eField(:, 1) > es.time, 1);
    es.vector = es.vector + (-pc.e) * cc.eField(index, 2)*cc.direction*dv.valley.flyTime / pc.hbar;
    es = dv.valley.modifyElectricWaveVector(es, pc);
    es = dv.valley.computeEnergyAndGroupVelocity(es, pc);
    es.position = es.position + es.velocity * dv.valley.flyTime;
    
    vectorMold = sqrt(sum((vectorTemp - es.vector).^2));
    es.perdrift = abs(es.energy - energyTemp) / (pc.hbar * vectorMold);
end