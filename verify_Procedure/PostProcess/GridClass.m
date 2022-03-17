classdef GridClass < handle
    
    properties
        face
        point
    end
    
    methods
        
        function obj = GridClass(min, max, N)
            %构造函数
            obj.meshGrid(min, max, N);
            
        end
        
        function meshGrid(obj, min, max, N)
            %网格划分
            delta = (max - min) / N;
            obj.face = zeros(N + 1, 1);
            obj.point = zeros(N + 2, 1);
            obj.face(1) = min;
            obj.face(N+1) = max;
            obj.point(1) = min;
            obj.point(N+2) = max;
            for k = 2 : N + 1
                obj.face(k) = (k - 1) * delta + obj.face(1);
                obj.point(k) = (obj.face(k) + obj.face(k - 1)) * 0.5;
            end
            
        end
        
    end
end