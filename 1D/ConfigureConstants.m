classdef ConfigureConstants < Data2ColocatedField
    %% 运行参数类
    properties(Constant)
        e = 1.602176634e-19;
    end
    
    properties
        filePath
        xsfornDot
        xsforSourceB
        envTemp
        noFly
        maxVelocity
        maxFrequency
        initValley
        mLength
        mWidth
        localWorkers
    end
    
    methods
        function obj = ConfigureConstants(~)
            %>构造函数
            obj.superElecs = 200;
            obj.noFly = 30000;
            
            obj.localWorkers = 20;
            obj.xsfornDot = 1;%1e8
            obj.xsforSourceB = 9e20;
            obj.envTemp = 300;
            obj.maxVelocity = 3e5;
            obj.maxFrequency = 10e13;
            obj.initValley = 11;
            obj.dSource = 0;
            obj.mLength = 0.3e-6;
            obj.mWidth = 0.1e-6;
            obj.NX = 50;
            obj.NY = 1;
            obj.NW = 50;
            obj.filePath = '/home/jiang/documents/eMdatas';
            obj.modelMeshAndBuildNodesAndReadData;
        end
        
        function modelMeshAndBuildNodesAndReadData(obj)
            %>构建节点和读取数据
            obj.frequencyGrid(0, obj.maxFrequency, obj.NW);
            obj.modelXGrid(0, obj.mLength, obj.NX);
            obj.modelYGrid(0, obj.mWidth, obj.NY);
            obj.buildModelNodes;
            obj.data2ColocatedField;
            obj.computeSuperElectricCharge;
        end
        
    end
end
