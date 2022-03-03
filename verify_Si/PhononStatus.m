classdef PhononStatus
    
    properties
        position
        vector
        time
        aborem
        polar
        wavenum
        frequency
        energy
    end
    
    methods
        
%         function obj = PhononStatus
%             %构造函数
%             
%         end
        
        function wavenum = get.wavenum(obj)
            %波数在被调用时计算
            wavenum = sqrt(sum(obj.vector.^2));
        end
        
        function energy = get.energy(obj)
            %能量在被调用时计算
            energy = obj.frequency * PhysicConstants.hbar;
        end
        
        function obj = GetFrequency(obj, sc)
            %计算频率
            obj.frequency = sc.PhononFrequency(obj);
        end
        
    end
    
    
end