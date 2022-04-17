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
    end
    
    methods
        function obj = ConfigureConstants
            obj.superElecs = 200;
            obj.envTemp = 300;
            obj.noFly = 100;
            obj.maxVelocity = 3e5;
            obj.dopDensity = 1e23;
            obj.initValley = 1;
%             pointA = [0.0000000000	0.0000000000	0.6106662907];
%             pointM = [0.9957671513	0.5749064329	0.0000000000];
            eFieldMold = -10e5;
%             obj.electricField = eFieldMold * pointM/(sqrt(sum(pointM.^2)));
            obj.electricField = [eFieldMold 0 0];
        end
        
    end
end
