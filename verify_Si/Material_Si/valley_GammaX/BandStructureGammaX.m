classdef BandStructureGammaX < handle
    
    properties
        material
        mt
        ml
        Eg
        alpha
        Tz
        invTz
    end
    
    methods
        
        function obj = BandStructureGammaX(material, pc)
            %构造函数
            if strcmpi(material, "Si")
                obj.material = material;
                obj.mt = 0.196*pc.m;
                obj.ml = 0.916*pc.m;
                obj.Eg = 0.2*pc.e;
                obj.alpha = 0.5;
                obj.Tz = [sqrt(pc.m / obj.mt)    0   0;
                            0   sqrt(pc.m / obj.mt)  0;
                            0   0   sqrt(pc.m / obj.ml)];
                obj.invTz = inv(obj.Tz);
            else
                error("请使用材料：Si 的BandStructure类!")
            end
            
        end
        
        function es = computeEnergyAndVelocity(obj, es, pc)
            %计算电子能量
            tempk = obj.rotateToZAxisValley(es.vector, es.valley);
            k = tempk - [0, 0, 0.85] * pc.dGX;
            epsilong = pc.hbar^2 * ...
                         (k(1)^2 / obj.mt + k(2)^2 / obj.mt + k(3)^2 / obj.ml) / 2;
            es.energy = epsilong * (1 + epsilong/pc.e * obj.alpha);
            %计算电子速度
            kStar = obj.Tz * k';
            vStar = pc.hbar * kStar / (pc.m * (1+2*obj.alpha*epsilong));
            velocity = (obj.invTz * vStar)';
            es.velocity = obj.rotateToOtherAxisValley(velocity, es.valley);
            
        end
        
        function es = chooseWaveVector(obj, es, pc)
            %根据能量选择电子波矢
            epsilong = (sqrt(1 + 4*obj.alpha*es.energy/pc.e) - 1) / (2*obj.alpha) * pc.e;
            kStarMold = sqrt(2 * pc.m * epsilong) / pc.hbar;
            condition = true;
            while condition
                %球空间随机选择波矢
                phi = randnumber(0, pi);
                theta = randnumber(0, 2*pi);
                kxStar = kStarMold * sin(phi) * cos(theta);
                kyStar = kStarMold * sin(phi) * sin(theta);
                kzStar = kStarMold * cos(phi);
                kStar = [kxStar, kyStar, kzStar]';
                k = (obj.invTz * kStar)';
                tempk = k + [0, 0,  0.85] * pc.dGX;
                es.vector = obj.rotateToOtherAxisValley(tempk, es.valley);
                condition = double(max(abs(es.vector)) / pc.dGX) >= 1.0;
            end
            
        end
        
        function es = initializeElectricStatus(obj, es, pc, cc)
            %电子初始化
            es.position = [0 0 0];
            es.energy = maxwellDistribution(pc, cc);
            es.valley = ScatterringProcess.randomValley(es, "i");
            es = obj.chooseWaveVector(es, pc);
            es = obj.computeEnergyAndVelocity(es, pc);
            
        end
        
        function es = electricWhetherBeyondBZone(obj, es, pc)
            %判断是否超出第一布里渊区,并对波矢进行修正
            if double(max(abs(es.vector)) / pc.dGX) > 1.0
                switch es.valley
                    case 1
                        es.vector(1) = es.vector(1) - 2 * pc.dGX;
                    case -1
                        es.vector(1) = es.vector(1) + 2 * pc.dGX;
                    case 2
                        es.vector(2) = es.vector(2) - 2 * pc.dGX;
                    case -2
                        es.vector(2) = es.vector(2) + 2 * pc.dGX;
                    case 3
                        es.vector(3) = es.vector(3) - 2 * pc.dGX;
                    case -3
                        es.vector(3) = es.vector(3) + 2 * pc.dGX;
                    otherwise
                        error("能谷编号错误！")
                end
                es.valley = obj.whichValley(es);
            end
            
        end
        
        function ps = phononWhetherBeyondBZone(~, ps, pc)
            %声子波矢长度修正
            if double(ps.wavenum / pc.bzR) > 1.0
                ps.vector(1) = ps.vector(1) - 2 * pc.dGX * ps.vector(1) / ps.wavenum;
                ps.vector(2) = ps.vector(2) - 2 * pc.dGX * ps.vector(2) / ps.wavenum;
                ps.vector(3) = ps.vector(3) - 2 * pc.dGX * ps.vector(3) / ps.wavenum;
            end
            
        end
        
        function bandStructurePlot(obj, num, pc)
            %电子能带画图
            energyGX = zeros(num, 2);
            tempk = linspace(0.01, 1, num);
            es = ElectricStatus;
            for i = 1 : num
                es.vector = [tempk(i) 0 0] * pc.dGX;
                es.valley = obj.whichValley(es);
                es = obj.computeEnergyAndVelocity(es, pc);
                energyGX(i, 1) = es.vector(1) / pc.dGX;
                energyGX(i, 2) = es.energy / pc.e;
            end
            figure
            plot(energyGX(:,1), energyGX(:,2))
            xlabel("k/dGX")
            ylabel("Energy/(eV)")
            
        end
        
        function electricVelocityPlot(obj, num, pc)
            % 电子速度画图
            velocityGX = zeros(num, 2);
            tempk = linspace(0.01, 1, num);
            es = ElectricStatus;
            for i = 1 : num
                es.vector = [tempk(i) 0 0] * pc.dGX;
                es.valley = obj.whichValley(es);
                es = obj.computeEnergyAndVelocity(es, pc);
                velocityGX(i, 1) = es.vector(1) / pc.dGX;
                velocityGX(i, 2) = es.velocity(1);
            end
            figure
            plot(velocityGX(:,1),velocityGX(:,2))
            xlabel("k/dGX")
            ylabel("Velocity/(m/s)")
            
        end
        
    end
    
    methods(Static)
        
        function [value] = whichValley(es)
            %计算电子所在能谷
            [~, index] = max(abs(es.vector));
            item = es.vector(index) / abs(es.vector(index));
            value = index * item;
            
        end
        
        function [vector2] = rotateToOtherAxisValley(vector1, valley)
            %从Z轴正向能谷转向其他能谷
            switch valley
                case 1
                    vector2 = vector1*rotateMatrix(-pi/2, "y");
                case -1
                    vector2 = vector1*rotateMatrix(pi/2, "y");
                case 2
                    vector2 = vector1*rotateMatrix(pi/2, "x");
                case -2
                    vector2 = vector1*rotateMatrix(-pi/2, "x");
                case 3
                    vector2 = vector1*rotateMatrix(0, "x");
                case -3
                    vector2 = vector1*rotateMatrix(-pi, "x");
            end
            
        end
        
        function [vector2] = rotateToZAxisValley(vector1, valley)
            %从其他能谷转向Z轴正向能谷
            switch valley
                case 1
                    vector2 = vector1*rotateMatrix(pi/2, "y");
                case -1
                    vector2 = vector1*rotateMatrix(-pi/2, "y");
                case 2
                    vector2 = vector1*rotateMatrix(-pi/2, "x");
                case -2
                    vector2 = vector1*rotateMatrix(pi/2, "x");
                case 3
                    vector2 = vector1*rotateMatrix(0, "x");
                case -3
                    vector2 = vector1*rotateMatrix(pi, "x");
            end
            
        end
        
    end
end