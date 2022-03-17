function [es] = freeFlyProcess(es, dv, pc, cc)
    %自由飞行过程
    energyTemp = es.energy;
    vectorTemp = es.vector;
    dv.sr.computeFlyTime;
    es.vector = es.vector + (-pc.e) * cc.electricField * dv.sr.flyTime / pc.hbar;
    es.valley = dv.whichValley(es);
    dv.judgeBsSrSp(es);
%     es = dv.bs.modifyElectricWaveVector(es, pc);
    es = dv.bs.computeEnergyAndVelocity(es, pc);
    es.position = es.position + es.velocity * dv.sr.flyTime;
    es.time = es.time + dv.sr.flyTime;
    vectorMold = sqrt(sum((vectorTemp - es.vector).^2));
    es.perdrift = (es.energy - energyTemp) / (pc.hbar * vectorMold);
end