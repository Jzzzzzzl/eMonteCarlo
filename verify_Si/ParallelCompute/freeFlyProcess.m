function [es] = freeFlyProcess(es, bs, sr, pc, cc)
    %自由飞行过程
    energyTemp = es.energy;
    vectorTemp = es.vector;
    es.vector(1) = es.vector(1) + (-pc.e) * cc.electricField * sr.flyTime / pc.hbar;
    es.valley = bs.whichValley(es);
    es = bs.electricWhetherBeyondBZone(es, pc);
    es = bs.computeEnergyAndVelocity(es, pc);
    es.position = es.position + es.velocity * sr.flyTime;
    es.time = es.time + sr.flyTime;
    vectorMold = sqrt(sum((vectorTemp - es.vector).^2));
    es.perdrift = (es.energy - energyTemp) / (pc.hbar * vectorMold);
    
end