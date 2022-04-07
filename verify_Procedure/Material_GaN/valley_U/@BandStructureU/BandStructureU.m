classdef BandStructureU < BandStructureForValley
    %% U能谷
    methods
        function obj = BandStructureU(pc)
            %>构造函数
            obj.Eg = pc.EgU;
            obj.mt = pc.mtU;
            obj.ml = pc.mlU;
            obj.alpha = pc.alphaU;
            obj.centerRatio = pc.centerRatioU;
            obj.md = (obj.mt^2*obj.ml)^(1/3);
            obj.Tz = [sqrt(pc.m / obj.mt)    0   0;
                        0   sqrt(pc.m / obj.mt)  0;
                        0   0   sqrt(pc.m / obj.ml)];
            obj.invTz = inv(obj.Tz);
        end
        
        function [es] = chooseElectricWaveVector(obj, es, pc, theta)
            %>根据能量选择电子波矢
            es.epsilon = es.energy - obj.Eg;
            es.gamma = es.epsilon*(1 + obj.alpha*es.epsilon/pc.e);
            kStarMold = sqrt(2*pc.m*es.gamma) / pc.hbar;
            %>球空间随机选择波矢
            condition = true;
            while condition
                phi = randNumber(0, 2*pi);
                kxStar = kStarMold * sin(theta) * cos(phi);
                kyStar = kStarMold * sin(theta) * sin(phi);
                kzStar = kStarMold * cos(theta);
                kStar = [kxStar, kyStar, kzStar]';
                k = (obj.invTz * kStar)';
                tempk = k + [0, 0,  obj.centerRatio] * pc.dBD;
                es.vector = obj.rotateToGeneralValley(tempk, es.valley);
                condition = obj.whetherBeyondBrillouinZone(es, pc);
            end
        end
        
        function [es] = computeEnergyAndGroupVelocity(obj, es, pc)
            %>计算电子能量
            tempk = obj.rotateToStandardValley(es.vector, es.valley);
            k = tempk - [0, 0, obj.centerRatio] * pc.dBD;
            es.gamma = pc.hbar^2*(k(1)^2 / obj.mt + k(2)^2 / obj.mt + k(3)^2 / obj.ml) / 2;
            es.epsilon = (-1 + sqrt(1 + 4*obj.alpha*es.gamma/pc.e)) * pc.e / (2*obj.alpha);
            es.energy = es.epsilon + obj.Eg;
            %>计算电子速度
            kStar = obj.Tz * k';
            vStar = pc.hbar * kStar / (pc.m * (1 + 2*obj.alpha*es.epsilon/pc.e));
            velocity = (obj.invTz * vStar)';
            es.velocity = obj.rotateToGeneralValley(velocity, es.valley);
        end
    end
end