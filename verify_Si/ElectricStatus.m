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
    end
    
    methods
        
        function obj = ElectricStatus
            %构造函数
            
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
        
        
    end
    
    methods(Static)
        
        function [value] = Random(a, b)
            value = a + rand * (b - a);
        end
        
    end
    
    
end