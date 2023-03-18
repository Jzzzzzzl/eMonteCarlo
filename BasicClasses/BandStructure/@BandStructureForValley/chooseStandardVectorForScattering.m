function [k] = chooseStandardVectorForScattering(obj, es, pc, frequency, flag)
    %>选择散射末态电子标准波矢
    %      flag：吸收(+1)或发射(-1)
    if nargin == 3%>弹性散射
        k = obj.generateStandardElectricWaveVector(es, pc);
    else%>非弹性散射
        phononEnergy = double(pc.hbar * frequency);
        es.energy = es.energy + flag * phononEnergy;
        k = obj.generateStandardElectricWaveVector(es, pc);
    end
end