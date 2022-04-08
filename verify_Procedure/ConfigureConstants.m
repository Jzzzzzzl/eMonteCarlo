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
        initEnergy
        maxVelocity
    end
    
    methods
        function obj = ConfigureConstants
            obj.superElecs = 1000;
            obj.envTemp = 300;
            obj.noFly = 3000;
            obj.initEnergy = 0.0001*obj.e;
            obj.maxVelocity = 3e7;
            obj.dopDensity = 1e23;
            obj.electricField = [-1.5e7 0 0];
        end
        
    end
end
