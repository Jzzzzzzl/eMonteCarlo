function [es] = freeFlyProcess(es, bs, sr, pc, cc)
    %自由飞行过程
    es.vector(1) = es.vector(1) + (-pc.e) * cc.electricField * sr.flyTime / pc.hbar;
    es.valley = bs.whichValley(es);
    es = bs.electricWhetherBeyondBZone(es, pc);
    es = bs.computeInParabolicFactor(es, pc);
    es.energy = bs.computeElectricEnergy(es, pc);
    es.velocity = bs.computeElectricVelocity(es, pc);
    es.position = es.position + es.velocity * sr.flyTime;
    es.time = es.time + sr.flyTime;
    
end