classdef BoundaryReflection < ModelMeshing
    %% MESFET型结构边界反射类
    properties
        nodes
    end
    
    methods
        buildModelNodes(obj)
        [bool] = boundReflection(obj, rAgo, es)
    end
    
end