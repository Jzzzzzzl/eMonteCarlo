function [es] = FreeFlyProcess(es, bs, sr, pc, cc)
    %自由飞行过程
    
    es.vector(1) = es.vector(1) + (-pc.e) * cc.electricField * sr.flyTime / pc.hbar;
    es.WhichValleyNum;
    es.WhetherBeyondBrillouinZone(pc);
    es.ComputeInParabolicFactor(pc);
    es.energy = bs.ComputeElectricEnergy(es, pc);
    es.velocity = bs.ComputeElectricVelocity(es, pc);
    es.position = es.position + es.velocity * sr.flyTime;
    es.time = es.time + sr.flyTime;
    
end