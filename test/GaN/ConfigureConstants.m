classdef ConfigureConstants < Data2ColocatedField
    %% 运行参数类
    properties(Constant)
        e =1.602176634e-19;
    end
    
    properties
        noFly
        envTemp
        maxVelocity
        maxFrequency
        initValley
        mLength
        mWidth
        eField
        dopdensity
    end
    
    methods
        function obj = ConfigureConstants
            obj.superElecs = 100;
            obj.noFly = 2000;
            obj.eField = [6e-12 -3e7
                             1 -0.1e6];
%             obj.eField = [6e-12 -1e7
%                              12e-12 -0.1e6
%                              1 -1e7];
%             obj.eField = [6e-12 -0.1e6
%                              12e-12 -5e7
%                              1 -0.1e6];
%             obj.eField = [1 -0.1e6];
            obj.dopdensity = 1e23;
            
            obj.envTemp = 300;
            obj.maxVelocity = 3e7;
            obj.maxFrequency = 1.5e14;
            obj.initValley = 11;
            obj.dSource = 0;
            obj.mLength = 1;
            obj.mWidth = 1;
            obj.NX = 1;
            obj.NY = 1;
            obj.NW = 100;
            obj.modelMeshAndBuildNodesAndReadData;
        end
        
        function modelMeshAndBuildNodesAndReadData(obj)
            %>构建节点和读取数据
            obj.frequencyGrid(0, obj.maxFrequency, obj.NW);
            obj.modelXGrid(0, obj.mLength, obj.NX);
            obj.modelYGrid(0, obj.mWidth, obj.NY);
            obj.eleConc = ColocateField(obj, obj.dopdensity);
            obj.dopDensity = ColocateField(obj, obj.dopdensity);
            obj.computeSuperElectricCharge;
        end
        
    end
end
