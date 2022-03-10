classdef ElectricStatus < handle
    %电子状态类
    
    properties
        position
        vector
        valley
        wavenum
        energy
        velocity
        charge
        scatype
        eipara
        vipara
        time
    end
    
    methods
        
        function obj = ElectricStatus
            %构造函数
            
            obj.eipara = 1;
            obj.vipara = 1;
            obj.time = 0;
            
        end
        
        function wavenum = get.wavenum(obj)
            %自动计算电子波数
            
            wavenum = sqrt(sum(obj.vector.^2));
            
        end
        
        function initializeStatus(obj, bs, pc)
            %初始化电子状态
            
            obj.position = [0 0 0];
            obj = bs.initializeVector(obj, pc, cc);
            
            
            
        end
        
        function ComputeInParabolicFactor(obj, pc)
            %计算能量和速度非抛物线型参数
            
            tempk = BandStructure.RotateToZAxisValley(obj.vector, obj.valley);
            tempk0 = tempk - [0, 0, 0.85] * pc.dGX;
            %Herring-Vogt变换(Z正轴)
            Tz = [sqrt(pc.m / pc.mt)    0   0;
                    0   sqrt(pc.m / pc.mt)  0;
                    0   0   sqrt(pc.m / pc.ml)];
            tempw = Tz * tempk0';
            tempx = double(sqrt(sum(tempw.^2)) / (pc.bzR));
            obj.eipara = abs(1 - log(real(tempx.^2) + 1) / log(2.7));
            obj.vipara = abs(1 - log(real(tempx.^2) + 1) / log(1.62));
            
        end
        
        function WhetherBeyondBrillouinZone(obj, pc)
            %判断是否超出第一布里渊区,并对波矢进行修正
            
            if double(max(abs(obj.vector)) / pc.dGX) > 1.0
                switch obj.valley
                    case 1
                        obj.vector(1) = obj.vector(1) - 2 * pc.dGX;
                    case -1
                        obj.vector(1) = obj.vector(1) + 2 * pc.dGX;
                    case 2
                        obj.vector(2) = obj.vector(2) - 2 * pc.dGX;
                    case -2
                        obj.vector(2) = obj.vector(2) + 2 * pc.dGX;
                    case 3
                        obj.vector(3) = obj.vector(3) - 2 * pc.dGX;
                    case -3
                        obj.vector(3) = obj.vector(3) + 2 * pc.dGX;
                    otherwise
                        error("能谷编号错误！")
                end
                obj.WhichValleyNum;
            end
        end
        
    end
end