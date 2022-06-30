function [es] = freeFlyProcess(es, dv, pc)
    %% 自由飞行过程
    energyTemp = es.energy;
    vectorTemp = es.vector;
    
    dv.valleyGuidingPrinciple(es);
    dv.valley.computeFlyTime(es);
    es.time = es.time + dv.valley.flyTime;
    es.vector = es.vector - pc.e * es.devField * dv.valley.flyTime / pc.hbar;
    es = dv.valley.modifyElectricWaveVector(es, pc);
    es = dv.valley.computeEnergyAndGroupVelocity(es, pc);
    %> method1
%     if es.devField(1) ~= 0
%         deltax = (es.energy - energyTemp) / (-pc.e * es.devField(1));
%     else
%         deltax = 0;
%     end
%     if es.devField(2) ~= 0
%         deltay = (es.energy - energyTemp) / (-pc.e * es.devField(2));
%     else
%         deltay = 0;
%     end
%     es.position = es.position + [deltax deltay 0];
    
    %> method2
%     es.position = es.position + es.velocity * dv.valley.flyTime;
    
    %> method3
    eFieldMold = sqrt(sum(es.devField.^2));
    if eFieldMold ~= 0
        deltar = (es.energy - energyTemp) / (pc.e * eFieldMold);
        deltax =  -deltar / eFieldMold * es.devField(1);
        deltay =  -deltar / eFieldMold * es.devField(2);
    else
        deltax = 0;
        deltay = 0;
    end
    es.position = es.position + [deltax deltay 0];
    
    vectorMold = sqrt(sum((vectorTemp - es.vector).^2));
    es.perdrift = (es.energy - energyTemp) / (pc.hbar * vectorMold);
    
end