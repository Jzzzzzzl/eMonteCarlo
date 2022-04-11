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
            obj.noFly = 10000;
            obj.maxVelocity = 3e7;
            obj.dopDensity = 1e23;
            obj.initValley = 11;
%             pointA = [0.0000000000	0.0000000000	0.6106662907];
            pointM = [0.9957671513	0.5749064329	0.0000000000];
            eFieldMold = -5e7;
            obj.electricField = eFieldMold * pointM/(sqrt(sum(pointM.^2)));
        end
        
    end
end
