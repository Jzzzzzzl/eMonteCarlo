classdef ElectricStatus < handle
    %% 本文件提供超电子对象父类
    properties
        %>电子ID
        id
        %>位矢
        position
        %>波矢
        vector
        %>能谷标号
        valley
        %>波数
        wavenum
        %>能量
        energy
        %>非抛物性能量
        gamma
        %>显示能量
        epsilon
        %>速度
        velocity
        %>超电子电荷量
        charge
        %>散射类型
        scatype
        %>时刻
        time
        %>漂移速度大小
        perdrift
        %>散射角
        theta
    end
    
    properties
        %>电场
        devField
        %>温度
        devTem
        %>掺杂浓度
        devDop
        %>电子浓度
        devCon
    end
    
    methods
        function initializeElectricStatus(obj, dv, pc, cc)
            %>电子初始化
            obj.time = 0;
            obj.devField = [-1.3e6 0 0];
            obj.perdrift = 0;
            obj.valley = cc.initValley;
            obj.position(1) = randNumber(cc.initPosition(1), cc.initPosition(2));
            obj.position(2) = randNumber(cc.initPosition(3), cc.initPosition(4));
            obj.position(3) = 0;
            obj.theta = randNumber(0, pi);
            obj.charge = cc.superElecCharge;
            dv.valleyGuidingPrinciple(obj);
            obj.energy = maxwellDistribution(pc, cc) + dv.valley.Eg;
            k = dv.valley.generateStandardElectricWaveVector(obj, pc);
            obj = dv.valley.getGeneralElectricWaveVector(obj, pc, k);
        end
        
%         function wavenum = get.wavenum(obj)
%             %>自动计算电子波数
%             wavenum = sqrt(sum(obj.vector.^2));
%         end
        
    end
end