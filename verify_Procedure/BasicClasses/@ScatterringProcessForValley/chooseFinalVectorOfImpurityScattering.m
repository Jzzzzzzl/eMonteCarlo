function [es] = chooseFinalVectorOfImpurityScattering(~, es, dv, pc)
    %>电离杂质散射后选择电子波矢
    agov = es.velocity;
    agovMold = sqrt(sum(agov.^2));

    item = 0;
    condition = true;
    allowedError = 0.1;
    while condition && item < 20
        es = dv.bs.chooseWaveVector(es, pc);
        es = dv.bs.computeEnergyAndVelocity(es, pc);
        afterv = es.velocity;
        aftervMold = sqrt(sum(afterv.^2));
        theta = acos(sum(agov .* afterv) / (agovMold * aftervMold));
        situ1 = theta < pi / 2;
        situ2 = (abs(agovMold - aftervMold) / agovMold) > allowedError;
        condition = situ1 | situ2;
        item = item + 1;
    end
end