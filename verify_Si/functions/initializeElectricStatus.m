function [es] = initializeElectricStatus(es, bs, pc, cc)
    %电子初始化
    es.position = [0 0 0];
    es.energy = maxwellDistribution(pc, cc);
    es.valley = 1;
    es = bs.chooseWaveVector(es, pc);
    es = bs.computeEnergyAndVelocity(es, pc);
end
        