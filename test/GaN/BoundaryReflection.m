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
        function [bool] = boundaryReflection(~, varargin)
            bool = false;
        end
    end
    
end