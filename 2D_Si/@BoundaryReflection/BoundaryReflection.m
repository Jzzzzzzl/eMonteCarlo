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
        buildModelNodes(obj)
        [bool] = boundaryReflection(obj, rAgo, es)
    end
    
    methods(Static)
        [theta] = directAngle(x1, y1, x2, y2, x3, y3)
    end
end