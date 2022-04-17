classdef ElectricStatus < handle
    %% 本文件提供超电子对象父类
    % ======================================================================
    %>     属性说明：
    %>     
    % ======================================================================
    properties
        position
        vector
        valley
        wavenum
        energy
        gamma
        epsilon
        velocity
        charge
        scatype
        time
        perdrift
    end
    
    methods
        function obj = ElectricStatus(dv, pc, cc)
            %>构造函数
            obj.time = 0;
            if nargin == 3
                obj = initializeElectricStatus(obj, dv, pc, cc);
            end
        end
        
        function wavenum = get.wavenum(obj)
            %>自动计算电子波数
            wavenum = sqrt(sum(obj.vector.^2));
        end
        
    end
end