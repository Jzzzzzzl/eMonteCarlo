classdef BoundaryReflection < ModelMeshing
    %% Gunn型结构边界反射类
    methods
        function [bool] = boundReflection(obj, ~, es)
            x = es.position(1);
            if ge(x, obj.modelx.face(end)) || le(x, obj.modelx.face(1))
                bool = true;
            else
                bool = false;
            end
        end
    end
end