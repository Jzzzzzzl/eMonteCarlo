function [es] = chooseWaveVector(obj, es, pc)
    %>根据能量选择电子波矢
    condition = true;
    while condition
        k = obj.generateStandardWaveVector(es, pc);
        tempk = k + [0, 0,  obj.centerRatio] * pc.dGX;
        es.vector = obj.rotateToGeneralValley(tempk, es.valley);
        condition = obj.whetherBeyondBrillouinZone(es, pc);
    end
end