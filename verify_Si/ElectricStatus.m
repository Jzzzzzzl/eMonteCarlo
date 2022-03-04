classdef ElectricStatus
    
    properties
        position
        vector
        velocity
        charge
        valley
        scatype
        time
        wavenum
        energy
        vipara
        eipara
    end
    
    methods
        
        function obj = ElectricStatus
            %构造函数
            
            obj.vipara = 1;
            obj.eipara = 1;
        end
        
        function wavenum = get.wavenum(obj)
            wavenum = sqrt(sum(obj.vector.^2));
        end
        
        function energy = get.energy(obj)
            energy = obj.velocity * 0;
        end
        
        function obj = InitializeStatus(obj, cc)
            %初始化
            obj.energy = cc.initEnergy;
            obj.position = [0 0 0];
            obj.RandomValley(obj);
        end
        
        
        function obj = RandomValley(obj)
            %随机选择能谷
            valleys = [1 -1 2 -2 3 -3];
            index = round(obj.Random(0.5, 6.5));
            obj.valley = valleys(index);
        end
        
        function obj = ComputeInParabolicFactor(obj, bs, pc)
            %计算能量和速度非抛物线型参数
            kitem = bs.RotateToZAxisValley(obj.vector, obj.valley);
            k0 = kitem - [0, 0, 0.85] * pc.dGX;
            %Herring-Vogt变换(Z正轴)
            Tx = [sqrt(pc.m / pc.mt)    0   0;
                    0   sqrt(pc.m / pc.mt)  0;
                    0   0   sqrt(pc.m / pc.ml)];
            w = Tx*k0';
            mm = double(sqrt(sum(w.^2)) / pc.bzR);
            obj.eipara = (1-log(real(mm.^2)+1)/log(2.7));
            obj.vipara = (1-log(real(mm.^2.2)+1)/log(1.6));
        end
        
    end
    
    methods(Static)
        
        function [value] = Random(a, b)
            value = a + rand * (b - a);
        end
        
    end
    
    
end