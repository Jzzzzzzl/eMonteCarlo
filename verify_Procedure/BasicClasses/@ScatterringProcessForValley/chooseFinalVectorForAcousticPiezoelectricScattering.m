function [es] = chooseFinalVectorForAcousticPiezoelectricScattering(~, es, dv, pc)
    %>压电散射后选择电子波矢（弹性）
    if ~isempty(dv.sr.thetaAP)
        es = dv.bs.chooseWaveVector(es, pc, dv.sr.thetaAP);
    else
        error("未计算压电散射散射角！")
    end
end