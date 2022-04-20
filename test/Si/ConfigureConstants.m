classdef ConfigureConstants < handle
    %% 运行参数类
    properties(Constant)
        e =1.602176634e-19;
    end
    
    properties
        dopDensity
        superElecs
        envTemp
        electricField
        noFly
        maxVelocity
        initValley
        NW
    end
    
    methods
        function obj = ConfigureConstants
            obj.superElecs = 20;
            obj.envTemp = 300;
            obj.noFly = 1000;
            obj.maxVelocity = 3e5;
            obj.dopDensity = 1e23;
            obj.initValley = 1;
            eFieldMold = -10e5;
            obj.electricField = [eFieldMold 0 0];
            obj.NW = 20;
        end
        
    end
end
