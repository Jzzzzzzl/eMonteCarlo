classdef BandStructure < handle
    
    properties
        material
    end
    
    
    methods
        
        function obj = BandStructure(material)
            %能带曲线
            if strcmpi(material, "Si")
                obj.material = material;
            else
                error("请使用材料：Si 的BandStructure类!")
            end
            
        end
        
        function es = initializeElectricStatus(obj, es, pc, cc)
            %电子初始化
            es.position = [0 0 0];
            es.energy = maxwellDistribution(pc, cc);
            es.valley = ScatterringProcess.randomValley(es, "i");
            es = obj.chooseWaveVector(es, pc);
            es = obj.computeInParabolicFactor(es, pc);
            es.energy = obj.computeElectricEnergy(es, pc);
            es.velocity = obj.computeElectricVelocity(es, pc);
            
        end
        
        function es = computeInParabolicFactor(obj, es, pc)
            %计算能谷非抛物线性参数
            tempk = obj.rotateToZAxisValley(es.vector, es.valley);
            tempk0 = tempk - [0, 0, 0.85] * pc.dGX;
            %Herring-Vogt变换(Z正轴)
            Tz = [sqrt(pc.m / pc.mt)    0   0;
                    0   sqrt(pc.m / pc.mt)  0;
                    0   0   sqrt(pc.m / pc.ml)];
            tempw = Tz * tempk0';
            tempx = double(sqrt(sum(tempw.^2)) / (pc.bzR));
            es.eipara = abs(1 - log(real(tempx.^2) + 1) / log(2.7));
            es.vipara = abs(1 - log(real(tempx.^2) + 1) / log(1.62));
            
        end
        
        function es = chooseWaveVector(obj, es, pc)
            %根据能量选择电子波矢
            n = 10; %椭球点密集程度
            energyTemp = es.energy / es.eipara;
            rx = real(sqrt(2 * energyTemp * pc.mt) / pc.hbar);
            ry = real(sqrt(2 * energyTemp * pc.mt) / pc.hbar);
            rz = real(sqrt(2 * energyTemp * pc.ml) / pc.hbar);
            [xm, ym, zm] = ellipsoid(0, 0, 0, rx, ry, rz, n);
            
            condition = true;
            while condition
                %可通过控制randx与randy的范围实现椭球面位置取值
                randx = round(rand(1)*(n - 1)) + 1;
                randy = round(rand(1)*(n - 1)) + 1;
                x = xm(randx, randy);
                y = ym(randx, randy);
                z = zm(randx, randy);
                tempk = [x, y, z] + [0, 0,  0.85] * pc.dGX;
                es.vector = obj.rotateToOtherAxisValley(tempk, es.valley);
                condition = double(max(abs(es.vector)) / pc.dGX) >= 1.0;
            end
            
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
        
        function [energy] = computeElectricEnergy(obj, es, pc)
            %计算电子能量
            tempk = obj.rotateToZAxisValley(es.vector, es.valley);
            k0 = tempk - [0, 0, 0.85] * pc.dGX;
            energy = es.eipara * pc.hbar^2 * ...
                         (k0(1)^2 / pc.mt + k0(2)^2 / pc.mt + k0(3)^2 / pc.ml) / 2;
%             if es.energy > EnergyMax
%                 es.energy = EnergyMax;
%             end

        end
        
        function [velocity] = computeElectricVelocity(obj, es, pc)
            %计算电子速度
            tempk = obj.rotateToZAxisValley(es.vector, es.valley);
            k0 = tempk - [0, 0, 0.85] * pc.dGX;
            vx = es.vipara * pc.hbar * k0(1) / pc.mt;
            vy = es.vipara * pc.hbar * k0(2) / pc.mt;
            vz = es.vipara * pc.hbar * k0(3) / pc.ml;
            velocity = [vx, vy, vz];
            velocity = obj.rotateToOtherAxisValley(velocity, es.valley);
            
        end
        
        function bandStructurePlot(obj, num, pc)
            %电子能带画图
            energyGX = zeros(num, 2);
            tempk = linspace(0.01, 1, num);
            es = ElectricStatus;
            for i = 1 : num
                es.vector = [tempk(i) 0 0] * pc.dGX;
                es.valley = obj.whichValley(es);
                es = obj.computeInParabolicFactor(es, pc);
                energyGX(i, 1) = es.vector(1) / pc.dGX;
                energyGX(i, 2) = obj.computeElectricEnergy(es, pc) / pc.e;
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
                es = obj.computeInParabolicFactor(es, pc);
                velocityGX(i, 1) = es.vector(1) / pc.dGX;
                velocity = obj.computeElectricVelocity(es, pc);
                velocityGX(i, 2) = velocity(1);
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