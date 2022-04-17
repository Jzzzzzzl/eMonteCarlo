classdef ConfigureConstants < Data2ColocatedField & BoundaryReflection
    %% 运行参数类
    properties(Constant)
        e =1.602176634e-19;
    end
    
    properties
        superElecs
        envTemp
        noFly
        maxVelocity
        initValley
    end
    
    methods
        function obj = ConfigureConstants(mm)
            obj.superElecs = 20;
            obj.envTemp = 300;
            obj.noFly = 1000;
            obj.maxVelocity = 3e5;
            obj.initValley = 1;
            obj.dSource = 0.1e-6;
            obj.pGate = 0.2e-6;
            obj.dGate = 0.2e-6;
            obj.dDrain = 0.1e-6;
            obj.buildModelNodes(mm);
            obj.data2ColocatedField(mm);
        end
        
    end
end
