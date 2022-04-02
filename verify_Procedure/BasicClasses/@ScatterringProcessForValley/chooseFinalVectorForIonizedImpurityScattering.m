function [es] = chooseFinalVectorForIonizedImpurityScattering(~, es, dv, pc)
    %>电离杂质散射后选择电子波矢
    item = 0;
    condition = true;
    allowedError = 0.1;
    if isempty(dv.sr.thetaII)
        error("未计算压电散射散射角！")
    end
    agovMold = sqrt(sum(es.velocity.^2));
    while condition && item < 20
        es = dv.bs.chooseWaveVector(es, pc, dv.sr.thetaII);
        es = dv.bs.computeEnergyAndVelocity(es, pc);
        aftervMold = sqrt(sum(es.velocity.^2));
        condition = (abs(agovMold - aftervMold) / agovMold) > allowedError;
        item = item + 1;
    end
end