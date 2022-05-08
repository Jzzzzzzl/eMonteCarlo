classdef ElectricStatus < handle
    %% 本文件提供超电子对象父类
    properties
        position
        vector
        valley
        wavenum
        energy
        gamma
        epsilon
        velocity
        charge
        scatype
        time
        perdrift
    end
    
    methods
        
        function initializeElectricStatus(obj, dv, pc, cc)
            %>电子初始化
            obj.time = 0;
            obj.perdrift = 0;
            obj.valley = cc.initValley;
            obj.position(1) = randNumber(cc.modelx.face(1), cc.dSource);
            obj.position(2) = randNumber(cc.modely.face(end-1), cc.modely.face(end));
            obj.position(3) = 0;
            obj.charge = cc.superElecCharge;
            dv.valleyGuidingPrinciple(obj);
            obj.energy = maxwellDistribution(pc, cc) + dv.valley.Eg;
            k = dv.valley.generateStandardElectricWaveVector(obj, pc, randNumber(0, pi));
            obj = dv.valley.getGeneralElectricWaveVector(obj, pc, k);
        end
        
        function wavenum = get.wavenum(obj)
            %>自动计算电子波数
            wavenum = sqrt(sum(obj.vector.^2));
        end
        
    end
end