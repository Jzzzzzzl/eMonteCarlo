classdef BandStructureGammaX < BandStructureForValley
    %% GammaX能谷
    methods
        function obj = BandStructureGammaX(pc)
            %>构造函数
            obj.Eg = pc.EgGX;
            obj.mt = pc.mtGX;
            obj.ml = pc.mlGX;
            obj.alpha = pc.alphaGX;
            obj.centerRatio = pc.centerRatioGX;
            obj.md = (obj.mt^2*obj.ml)^(1/3);
            obj.Tz = [sqrt(pc.m / obj.mt)    0   0;
                        0   sqrt(pc.m / obj.mt)  0;
                        0   0   sqrt(pc.m / obj.ml)];
            obj.invTz = inv(obj.Tz);
        end
        
        function [es] = chooseElectricWaveVector(obj, es, pc, theta)
            %>根据能量选择电子波矢
            obj.epsilon = es.energy - obj.Eg;
            obj.gamma = obj.epsilon*(1 + obj.alpha*obj.epsilon/pc.e);
            kStarMold = sqrt(2*pc.m*obj.gamma) / pc.hbar;
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
            obj.gamma = pc.hbar^2*(k(1)^2 / obj.mt + k(2)^2 / obj.mt + k(3)^2 / obj.ml) / 2;
            obj.epsilon = (-1 + sqrt(1 + 4*obj.alpha*obj.gamma/pc.e)) * pc.e / (2*obj.alpha);
            es.energy = obj.epsilon + obj.Eg;
            %>计算电子速度
            kStar = obj.Tz * k';
            vStar = pc.hbar * kStar / (pc.m * (1 + 2*obj.alpha*obj.epsilon/pc.e));
            velocity = (obj.invTz * vStar)';
            es.velocity = obj.rotateToGeneralValley(velocity, es.valley);
        end
    end
end