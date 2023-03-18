classdef PhononStatus < handle
    %% 本文件提供超声子对象父类
    properties(Constant)
        hbar = 1.05457266e-34;
    end
    properties
        %>位矢
        position
        %>波矢
        vector
        %>波数
        wavenum
        %>频率
        frequency
        %>能量
        energy
        %>吸收或发射
        aborem
        %>极化类型
        polar
        %>时刻
        time
    end
    
    methods
        function initializePhononStatus(obj)
            %>构造函数
            obj.position = [0 0 0];
            obj.vector = [0 0 0];
            obj.time = 0;
            obj.polar = -1;%>>>>>>>>>>默认-1，未生成声子
            obj.aborem = -1;
            obj.frequency = 0;
        end
        
        function wavenum = get.wavenum(obj)
            %>波数在被调用时计算
            wavenum = sqrt(sum(obj.vector.^2));
        end
        
        function energy = get.energy(obj)
            %>能量在被调用时计算
            energy = obj.frequency * obj.hbar;
        end
        
        function getFrequency(obj, sc)
            %>计算频率
            obj.frequency = sc.phononFrequency(obj);
        end
        
    end
end