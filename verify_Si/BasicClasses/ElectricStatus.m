classdef ElectricStatus
    
    properties
        position
        vector
        velocity
        charge
        scatype
        time
        energy
        eipara
        vipara
        valley
        wavenum
    end
    
    methods
        
        function obj = ElectricStatus
            %构造函数
            
            obj.eipara = 1;
            obj.vipara = 1;
            
        end
        
        function wavenum = get.wavenum(obj)
            %自动计算电子波数
            
            wavenum = sqrt(sum(obj.vector.^2));
            
        end
        
        function obj = WhichValleyNum(obj)
            %更新电子所在能谷
            
            [~, index] = max(abs(obj.vector));
            item = obj.vector(index) / abs(obj.vector(index));
            obj.valley = index*item;
            
        end
        
        function obj = InitializeStatus(obj, bs, pc)
            %初始化
            
            obj.vector = [0.89 0 0]*pc.dGX;
            obj = obj.WhichValleyNum;
            obj.position = [0 0 0];
            obj = obj.ComputeInParabolicFactor(pc);
            obj.energy = bs.ComputeElectricEnergy(obj, pc);
            obj.velocity = bs.ComputeElectricVelocity(obj, pc);
            
        end
        
        function obj = ComputeInParabolicFactor(obj, pc)
            %计算能量和速度非抛物线型参数
            
            kitem = BandStructure.RotateToZAxisValley(obj.vector, obj.valley);
            k0 = kitem - [0, 0, 0.85] * pc.dGX;
            %Herring-Vogt变换(Z正轴)
            Tx = [sqrt(pc.m / pc.mt)    0   0;
                    0   sqrt(pc.m / pc.mt)  0;
                    0   0   sqrt(pc.m / pc.ml)];
            w = Tx*k0';
            mm = double(sqrt(sum(w.^2)) / (1.0 * pc.bzR));
            obj.eipara = abs(1-log(real(mm.^2)+1)/log(2.7));
            obj.vipara = abs(1-log(real(mm.^2)+1)/log(1.62));
            
        end
        
        function obj = WhetherBeyondBrillouinZone(obj, pc)
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
                        disp("能谷编号错误！")
                end
                obj = obj.WhichValleyNum;
            end
        end
        
    end
    
    methods(Static)
        
        
        
    end
end