function [es] = freeFlyProcess(es, dv, pc, cc)
    %% 自由飞行过程
    energyTemp = es.energy;
    vectorTemp = es.vector;
    dv.sr.computeFlyTime;
    time = dv.sr.flyTime;
    es.vector = es.vector + (-pc.e) * cc.electricField * time / pc.hbar;
    es.valley = dv.whichValley(es);
    dv.valleyGuidingPrinciple(es);
    es = dv.bs.modifyElectricWaveVector(es, pc);
    es = dv.bs.computeEnergyAndGroupVelocity(es, pc);
    es.position = es.position + es.velocity * time;
    es.time = es.time + time;
    vectorMold = sqrt(sum((vectorTemp - es.vector).^2));
    es.perdrift = (es.energy - energyTemp) / (pc.hbar * vectorMold);
end