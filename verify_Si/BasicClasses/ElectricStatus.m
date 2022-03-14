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
        time
    end
    
    methods
        
        function obj = ElectricStatus(bs, pc, cc)
            %构造函数
            obj.time = 0;
            if nargin == 3
                obj = bs.initializeElectricStatus(obj, pc, cc);
            end
            
        end
        
        function wavenum = get.wavenum(obj)
            %自动计算电子波数
            wavenum = sqrt(sum(obj.vector.^2));
            
        end
        
    end
end