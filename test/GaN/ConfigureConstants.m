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
            obj.superElecs = 20;
            obj.noFly = 500;       %0.0087ps/次飞行
%             obj.eField = [3e-12 -5e6
%                              6e-12 -5e7
%                              1 -5e6];
%             obj.generateElectricField(5);
            obj.eField = [1 -2e7];
            
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
        
        function generateElectricField(obj, N)
            %>生成电场索引数组
            deltaTime = 5e-12;
            obj.eField = zeros(N, 2);
            obj.eField(:, 1) = linspace(deltaTime, N*deltaTime, N);
            obj.eField(end, 1) = 1;
            obj.eField(:, 2) = -1*logspace(5, 8, N);
            disp(['建议飞行次数设置为： ', num2str(N*deltaTime*1e12 / 0.0087 * 1.3)]);
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
