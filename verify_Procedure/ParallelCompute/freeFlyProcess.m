function [es] = freeFlyProcess(es, dv, pc, cc)
    %% 自由飞行过程
    energyTemp = es.energy;
    vectorTemp = es.vector;
    
    dv.valleyGuidingPrinciple(es);
    dv.valley.computeFlyTime(es);
    es.time = es.time + dv.valley.flyTime;
    es.vector = es.vector + (-pc.e) * cc.electricField * dv.valley.flyTime / pc.hbar;
%     es = dv.valley.modifyElectricWaveVector(es, pc);
    es.valley = dv.whichValley(es);
    es = dv.valley.computeEnergyAndGroupVelocity(es, pc);
    es.position = es.position + es.velocity * dv.valley.flyTime;
    
    vectorMold = sqrt(sum((vectorTemp - es.vector).^2));
    es.perdrift = (es.energy - energyTemp) / (pc.hbar * vectorMold);
end