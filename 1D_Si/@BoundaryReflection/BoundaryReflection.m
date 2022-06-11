classdef BoundaryReflection < ModelMeshing
    %% Gunn型结构边界反射类
    properties
        d1
        d2
        d3
        mLength
        mWidth
        leftIndex
        rightIndex
        sczWidth   %电子积累层厚度
        initPosition
        
        xsforInduce
    end
    
    methods
        function [bool] = boundaryReflection(obj, ~, es)
            x = es.position(1);
            if ge(x, obj.modelx.face(end)) || le(x, obj.modelx.face(1))
                bool = true;
            else
                bool = false;
            end
        end
    end
end