function [es] = computeEnergyAndVelocity(obj, es, pc)
    %>计算电子能量和群速度
    tempk = obj.rotateToStandardValley(es.vector, es.valley);
    k = tempk - [0, 0, obj.centerRatio] * pc.dGM;
    [es.energy, velocity] = obj.computeEnergyVelocityForStandardVector(k, pc);
    es.velocity = obj.rotateToGeneralValley(velocity, es.valley);
end