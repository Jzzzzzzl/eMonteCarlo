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
        driftVelocity
        inParabolicFactor
        xsForimpurity
    end
    
    methods
        function obj = ConfigureConstants(Dimension)
            obj.superElecs = 20;
            obj.envTemp = 300;
            obj.noFly = 2000;
            obj.nofScat = 15;
            obj.initEnergy = 0.0001*obj.e;
            obj.energyMax = 2*obj.e;
            obj.driftVelocity = 2.5e5;
            obj.inParabolicFactor = 0.8;
            obj.xsForimpurity = 0.1;
            if strcmpi(Dimension, "1D")
                obj.dopDensity = 1e23;
                obj.electricField = -50e5;
            elseif strcmpi(Dimension, "2D")
                obj.dopDensity = [];
                obj.electricField = [];
            end
        end
        
    end
    
end