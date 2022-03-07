classdef GridClass < handle
    
    properties
        face
        point
    end
    
    methods
        
        function obj = GridClass(Min, Max, N)
            %构造函数
            
            obj.MeshGrid(Min, Max, N);
            
        end
        
        function MeshGrid(obj, Min, Max, N)
            %网格划分
            
            delta = (Max - Min) / N;
            obj.face = zeros(N + 1, 1);
            obj.point = zeros(N + 2, 1);
            obj.face(1) = Min;
            obj.face(N+1) = Max;
            obj.point(1) = Min;
            obj.point(N+2) = Max;
            for k = 2 : N + 1
                obj.face(k) = (k - 1) * delta + obj.face(1);
                obj.point(k) = (obj.face(k) + obj.face(k - 1)) * 0.5;
            end
            
        end
        
    end
end