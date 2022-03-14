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
        
        function obj = ConfigureConstants(Dimension)
            obj.superElecs = 2000;
            obj.envTemp = 300;
            obj.noFly = 1000;
            obj.nofScat = 16;
            obj.initEnergy = 0.0001*obj.e;
            obj.energyMax = 2*obj.e;
            obj.maxScatRate = 5e14;
            obj.maxVelocity = 3e5;
            obj.xsForimpurity = 0.1;
            if strcmpi(Dimension, "1D")
                obj.dopDensity = 1e23;
                obj.electricField = -1e5;
            elseif strcmpi(Dimension, "2D")
                obj.dopDensity = [];
                obj.electricField = [];
            end
        end
        
    end
    
end