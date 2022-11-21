function [es] = freeFlyProcess(es, dv, pc, cc)
    %% 自由飞行过程
    energyTemp = es.energy;
    vectorTemp = es.vector;
    
    dv.valleyGuidingPrinciple(es);
    dv.valley.computeFlyTime(es);
    es.time = es.time + dv.valley.flyTime;
    es.vector = es.vector - pc.e * es.devField * dv.valley.flyTime / pc.hbar;
    es = dv.valley.modifyElectricWaveVector(es, pc);
    es = dv.valley.computeEnergyAndGroupVelocity(es, pc);
    rAgo = es.position;
    es.position(1) = es.position(1) + abs(es.velocity(1)) * dv.valley.flyTime * cc.vxScale;
    es.position(2) = es.position(2) + abs(es.velocity(2)) * dv.valley.flyTime * cc.vyScale;
    bool = cc.boundaryReflection(rAgo, es);
    if bool
        timeTemp = es.time;
        es.initializeElectricStatus(dv, pc, cc);
        es.time = timeTemp;
    end
    
    vectorMold = sqrt(sum((vectorTemp - es.vector).^2));
    es.perdrift = (es.energy - energyTemp) / (pc.hbar * vectorMold);
    
end