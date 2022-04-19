classdef ConfigureConstants < Data2ColocatedField
    %% 运行参数类
    properties(Constant)
        e = 1.602176634e-19;
    end
    
    properties
        xsfornDot
        xsforSourceB
        envTemp
        noFly
        maxVelocity
        maxFrequency
        initValley
        mLength
        mWidth
        nx
        ny
        nw
        k
    end
    
    methods
        function obj = ConfigureConstants
            %>构造函数
            obj.superElecs = 20;
            obj.xsfornDot = 1e8;
            obj.xsforSourceB = 9e20;
            obj.envTemp = 300;
            obj.noFly = 5000;
            obj.maxVelocity = 3e5;
            obj.maxFrequency = 16e12;
            obj.initValley = 1;
            obj.dSource = 0.1e-6;
            obj.pGate = 0.2e-6;
            obj.dGate = 0.2e-6;
            obj.dDrain = 0.1e-6;
            obj.mLength = 0.6e-6;
            obj.mWidth = 0.5e-6;
            obj.nx = 20;
            obj.ny = 20;
            obj.nw = 100;
            obj.k = 148;
            obj.modelMeshAndBuildNodesAndReadData;
        end
        
        function modelMeshAndBuildNodesAndReadData(obj)
            %>构建节点和读取数据
            obj.frequencyGrid(0, obj.maxFrequency, obj.nw);
            obj.modelXGrid(0, obj.mLength, obj.nx);
            obj.modelYGrid(0, obj.mWidth, obj.ny);
            obj.buildModelNodes;
            obj.data2ColocatedField;
            obj.computeSuperElectricCharge;
        end
        
    end
end
