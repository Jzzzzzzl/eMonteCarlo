classdef PhononStatus < handle
    %% 本文件提供超声子对象父类
    % ======================================================================
    %>     属性说明：
    %>
    % ======================================================================
    %>     函数说明：
    %> （1）
    %>         
    %> （2）
    %>         
    %>
    % ======================================================================
    properties
        position
        vector
        wavenum
        frequency
        energy
        aborem
        polar
        time
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
        
        function getFrequency(obj, sc)
            %计算频率
            obj.frequency = sc.phononFrequency(obj);
        end
        
    end
end