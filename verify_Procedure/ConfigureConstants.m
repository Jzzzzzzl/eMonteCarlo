classdef ConfigureConstants < handle
    
    properties(Constant)
        e =1.602176634e-19;
    end
    
    properties
        dopDensity
        superElecs
        envTemp
        electricField
        noFly
        nofScat
        initEnergy
        energyMax
        maxScatRate
        maxVelocity
        xsForimpurity
    end
    
    methods
        
        function obj = ConfigureConstants
            obj.superElecs = 2000;
            obj.envTemp = 300;
            obj.noFly = 3000;
            obj.nofScat = 16;
            obj.initEnergy = 0.0001*obj.e;
            obj.energyMax = 2*obj.e;
            obj.maxScatRate = 3e14;
            obj.maxVelocity = 3e5;
            obj.xsForimpurity = 0.1;
            obj.dopDensity = 1e23;
            obj.electricField = [-0.1e5 0 0];
        end
        
    end
    
end