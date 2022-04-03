classdef BandStructureGamma3 < BandStructureForValley
    %% U能谷
    methods
        function obj = BandStructureGamma3(pc)
            %>构造函数
            obj.Eg = pc.EgG3;
            obj.mt = pc.mtG3;
            obj.ml = pc.mlG3;
            obj.alpha = pc.alphaG3;
            obj.centerRatio = pc.centerRatioG3;
            obj.md = (obj.mt^2*obj.ml)^(1/3);
            obj.Tz = [sqrt(pc.m / obj.mt)    0   0;
                        0   sqrt(pc.m / obj.mt)  0;
                        0   0   sqrt(pc.m / obj.ml)];
            obj.invTz = inv(obj.Tz);
        end
        function [es] = chooseElectricWaveVector(obj, es, pc, theta)
            %>根据能量选择电子波矢
            obj.gamma = es.energy - obj.Eg;
            obj.epsilon = (sqrt(1 + 4*obj.alpha*(obj.gamma)/pc.e) - 1) / (2*obj.alpha) * pc.e;
            kStarMold = sqrt(2 * pc.m * obj.epsilon) / pc.hbar;
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
            obj.epsilon = pc.hbar^2*(k(1)^2 / obj.mt + k(2)^2 / obj.mt + k(3)^2 / obj.ml) / 2;
            obj.gamma = obj.epsilon * (1 + obj.epsilon/pc.e * obj.alpha);
            es.energy = obj.gamma + obj.Eg;
            %>计算电子速度
            kStar = obj.Tz * k';
            vStar = pc.hbar * kStar / (pc.m * (1 + 2*obj.alpha*obj.epsilon/pc.e));
            velocity = (obj.invTz * vStar)';
            es.velocity = obj.rotateToGeneralValley(velocity, es.valley);
        end
    end
end
