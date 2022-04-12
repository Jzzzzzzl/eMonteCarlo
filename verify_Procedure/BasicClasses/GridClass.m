classdef GridClass < handle
    %% 网格划分类
    properties
        face
        point
    end
    
    methods
        
        function obj = GridClass(min, max, N, ratio, layerNum)
            %>构造函数
            obj.meshGrid(min, max, N, ratio, layerNum);
        end
        
        function meshGrid(obj, min, max, N, ratio, layerNum)
            %>网格划分
            obj.face = zeros(N + 1, 1);
            obj.point = zeros(N + 2, 1);
            obj.face(1) = min;
            obj.face(N+1) = max;
            obj.point(1) = min;
            obj.point(N+2) = max;
            if nargin == 4
                delta = (max - min) / N;
                for k = 2 : N + 1
                    obj.face(k) = (k - 1) * delta + obj.face(1);
                end
                for k = 2 : N + 1
                    obj.point(k) = (obj.face(k) + obj.face(k - 1)) * 0.5;
                end
            elseif nargin == 6
                delta = ratio*(max - min)/((1+ratio)^layerNum ...
                          * (1+ration*(N - layerNum)) - 1);
                for k = 2 : layerNum + 1
                    obj.face(k) = obj.face(k - 1) + delta * (1 + ratio)^(k - 2);
                end
                delta = (max - obj.face(layerNum + 1)) / (N - layerNum);
                for k = layerNum + 2 : N + 1
                    obj.face(k) = obj.face(k - 1) + delta;
                end
                for k = 2 : N + 1
                    obj.point(k) = (obj.face(k) + obj.face(k - 1)) * 0.5;
                end
            end
        end
        
    end
end