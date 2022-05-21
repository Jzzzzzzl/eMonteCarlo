classdef BoundaryReflection < ModelMeshing
    %% MESFET型结构边界反射类
    properties
        dSource
        pGate%>起始点
        dGate
        dDrain
        nodes
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