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
    end
    
    properties
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
        
        function valley = WhichValley(obj)
            %更新电子所在能谷
            
            [~, index] = max(abs(obj.vector));
            item = obj.vector(index) / abs(obj.vector(index));
            valley = index*item;
            
        end
        
        function obj = InitializeStatus(obj, cc)
            %初始化
            
            obj.energy = cc.initEnergy;
            obj.position = [0 0 0];
            obj.RandomValley(obj);
            
        end
        
        function value = RandomValley(obj, type)
            %随机选择能谷
            
            switch type
                case 'i'
                    valleys = [1, -1, 2, -2, 3, -3];
                    index = round(Random(0.5, 6.5));
                    value = valleys(index);
                case 'f'
                    valley0 = abs(obj.valley);
                    valleys1 = [2, -2, 3, -3];
                    valleys2 = [1, -1, 3, -3];
                    valleys3 = [1, -1, 2, -2];
                    index = round(Random(0.5, 4.5));
                    switch valley0
                        case 1
                            value = valleys1(index);
                        case 2
                            value = valleys2(index);
                        case 3
                            value = valleys3(index);
                    end
                case 'g'
                    value = -1*obj.valley;
            end
            
            
            
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
            obj.eipara = (1-log(real(mm.^2)+1)/log(2.7));
            obj.vipara = abs(1-log(real(mm.^2)+1)/log(1.62));
%             obj.eipara = abs(1-log(real(mm.^1.2)+1)/log(2.2));
%             obj.vipara = abs(1-log(real(mm.^2)+1)/log(1.62));
            
        end
        
    end
    
    methods(Static)
        
        
        
    end
end