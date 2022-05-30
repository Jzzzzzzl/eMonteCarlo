classdef ConfigureConstants < Data2ColocatedField
    %% 运行参数类
    properties(Constant)
        e = 1.602176634e-19;
    end
    properties
        xsforInduce
        xsfornDot
        xsforSourceB
        maxFrequency
        initValley
        localWorkers
        direction
        initTemp
    end
    
    methods
        function obj = ConfigureConstants(pc)
            %>构造函数
            obj.superElecs = 1000;
            obj.noFly = 10000;%0.0029455
            
            obj.initValley = 1;
            obj.initTemp = 300;
            obj.localWorkers = 20;
            obj.xsfornDot = 1;
            obj.xsforSourceB = 8e19;
            obj.maxFrequency = pc.maxFrequency;
            %>模型所需变量
            obj.d1 = 150e-9;
            obj.d2 = 20e-9;
            obj.d3 = 150e-9;
            obj.mWidth = 100e-9;
            obj.mLength = obj.d1+obj.d2+obj.d3;
            obj.xsforInduce = 0.0;
            obj.sczWidth = 10e-9;
            obj.initPosition = [319 320 0 100]*1e-9;
            obj.NX = 250;
            obj.NY = 1;
            obj.NW = 200;
            obj.direction = [1 0 0];
            %>文件所需变量
            obj.filePath = '/home/jiang/documents/eMdatas/epDatas/';
            obj.parGrid = linspace(0, obj.noFly, obj.localWorkers+1);
            obj.modelMeshAndBuildNodesAndReadData;
        end
        
        function modelMeshAndBuildNodesAndReadData(obj)
            %>划分网格并读取数据
            obj.frequencyGrid(0, obj.maxFrequency, obj.NW);
            obj.modelXGrid(0, obj.mLength, obj.NX);
            obj.modelYGrid(0, obj.mWidth, obj.NY);
            obj.data2ColocatedField;
            obj.deviceTemp = ColocateField(obj, obj.initTemp);
            obj.computeSuperElectricCharge;
            obj.leftIndex = find(obj.modelx.face >= obj.d1, 1) - 2;
            obj.rightIndex = find(obj.modelx.face >= (obj.d1+obj.d2), 1) + 2;
        end
        
    end
end
