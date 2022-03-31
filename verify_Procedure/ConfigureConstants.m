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
            obj.superElecs = 5000;
            obj.envTemp = 300;
            obj.noFly = 2000;
            obj.initEnergy = 0.0001*obj.e;
            obj.maxVelocity = 3e5;
            obj.dopDensity = 1e23;
            obj.electricField = [-10e5 0 0];
        end
        
    end
end