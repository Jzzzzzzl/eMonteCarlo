classdef BandStructureGammaX < BandStructureForValley
    
    methods
        
        function obj = BandStructureGammaX(pc)
            %构造函数
            obj.Eg = 0.2*pc.e;
            obj.mt = 0.196*pc.m;
            obj.ml = 0.916*pc.m;
            obj.alpha = 0.5;
            obj.Tz = [sqrt(pc.m / obj.mt)    0   0;
                        0   sqrt(pc.m / obj.mt)  0;
                        0   0   sqrt(pc.m / obj.ml)];
            obj.invTz = inv(obj.Tz);
            obj.centerRatio = 0.85;
        end
        
        function [es] = computeEnergyAndVelocity(obj, es, pc)
            %计算电子能量和群速度
            tempk = obj.rotateToStandardValley(es.vector, es.valley);
            k = tempk - [0, 0, obj.centerRatio] * pc.dGX;
            [es.energy, velocity] = obj.computeEnergyVelocityForStandardVector(k, pc);
            es.velocity = obj.rotateToGeneralValley(velocity, es.valley);
        end
        
        function [es] = chooseWaveVector(obj, es, pc)
            %根据能量选择电子波矢
            condition = true;
            while condition
                k = obj.generateStandardWaveVector(es, pc);
                tempk = k + [0, 0,  obj.centerRatio] * pc.dGX;
                es.vector = obj.rotateToGeneralValley(tempk, es.valley);
                condition = obj.whetherBeyondBrillouinZone(es, pc);
            end
        end
        
        function [es] = modifyElectricWaveVector(~, es, pc)
            %对超出第一布里渊区波矢进行修正
            if whetherBeyondBrillouinZone(es, pc)
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
                es.valley = DecideValleyKind.whichValley(es);
            end
        end
        
        function [ps] = phononWhetherBeyondBZone(~, ps, pc)
            %声子波矢长度修正
            if double(ps.wavenum / pc.dGX) > 1.0
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
                es.valley = DecideValleyKind.whichValley(es);
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
                es.valley = DecideValleyKind.whichValley(es);
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
        
        function [bool] = whetherBeyondBrillouinZone(es, pc)
            %判断电子波矢是否超出第一布里渊区
            bool = double(max(abs(es.vector)) / pc.dGX) > 1.0;
        end
        
        function [vector2] = rotateToStandardValley(vector1, valley)
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
        
        function [vector2] = rotateToGeneralValley(vector1, valley)
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
        
    end
end