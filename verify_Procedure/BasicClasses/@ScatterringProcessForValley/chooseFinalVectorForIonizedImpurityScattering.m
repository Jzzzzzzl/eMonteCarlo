function [es] = chooseFinalVectorForIonizedImpurityScattering(~, es, dv, pc)
    %>电离杂质散射后选择电子波矢
    item = 1;
    error = 1;
    maxitem = 20;
    allowedError = 0.1;
    
    agovMold = sqrt(sum(es.velocity.^2));
    while error > allowedError && item < maxitem
        es = dv.bs.chooseElectricWaveVector(es, pc, dv.sr.thetaII);
        es = dv.bs.computeEnergyAndGroupVelocity(es, pc);
        aftervMold = sqrt(sum(es.velocity.^2));
        error = abs((agovMold - aftervMold) / agovMold);
        item = item + 1;
    end
end