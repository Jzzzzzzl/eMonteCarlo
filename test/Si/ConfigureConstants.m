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
        direction
        dopdensity
    end
    
    methods
        function obj = ConfigureConstants(pc)
            obj.superElecs = 20;
            obj.noFly = 50;
            obj.eField = [1, -100e5];
%             obj.eField = [4e-12 -1e5
%                              1 -100e5];
%             obj.generateElectricField(5);
            obj.direction = [1 0 0];
            
            obj.dopdensity = 1e23;
            obj.envTemp = 300;
            obj.maxVelocity = 3e5;
            obj.maxFrequency = 10e13;
            obj.initValley = 1;
            obj.dSource = 0;
            obj.mLength = 1;
            obj.mWidth = 1;
            obj.NX = 1;
            obj.NY = 1;
            obj.NW = 100;
            obj.modelMeshAndBuildNodesAndReadData;
        end
        
        function generateElectricField(obj, N)
            %>生成电场索引数组
            deltaTime = 5.0e-12;
            obj.eField = zeros(N, 2);
            obj.eField(:, 1) = linspace(deltaTime, N*deltaTime, N);
            obj.eField(end, 1) = 1;
%             obj.eField(:, 2) = -1*linspace(0.1, 5, N)*1e6;
            obj.eField(:, 2) = -1*logspace(5, 7, N);
            disp(['建议飞行次数设置为： ', num2str(N*deltaTime*1e12 / 0.02 * 1.2)]);
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
