function [es] = chooseFinalVectorForAcousticPiezoelectricScattering(~, es, dv, pc)
    %>压电散射后选择电子波矢（弹性）
    es = dv.bs.chooseElectricWaveVector(es, pc, dv.sr.thetaAP);
    es = dv.bs.computeEnergyAndGroupVelocity(es, pc);
end