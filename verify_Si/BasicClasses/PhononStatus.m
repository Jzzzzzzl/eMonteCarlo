classdef PhononStatus < handle
    
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
        
        function obj = PhononStatus
            %构造函数
            
            obj.time = 0;
            obj.polar = "non";
            obj.aborem = "non";
            obj.frequency = 0;
            
        end
        
        function wavenum = get.wavenum(obj)
            %波数在被调用时计算
            
            wavenum = sqrt(sum(obj.vector.^2));
            
        end
        
        function energy = get.energy(obj)
            %能量在被调用时计算
            
            energy = obj.frequency * PhysicConstants.hbar;
            
        end
        
        function GetFrequency(obj, sc)
            %计算频率
            
            obj.frequency = sc.PhononFrequency(obj);
            
        end
        
        function WhetherBeyondBrillouinZone(obj, pc)
            %声子波矢长度修正
            
            if double(obj.wavenum / pc.bzR) > 1.0
                obj.vector(1) = obj.vector(1) - 2 * pc.dGX * obj.vector(1) / obj.wavenum;
                obj.vector(2) = obj.vector(2) - 2 * pc.dGX * obj.vector(2) / obj.wavenum;
                obj.vector(3) = obj.vector(3) - 2 * pc.dGX * obj.vector(3) / obj.wavenum;
            end
            
        end
        
    end
end