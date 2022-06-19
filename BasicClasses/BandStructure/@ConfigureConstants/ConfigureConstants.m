classdef ConfigureConstants < Data2ColocatedField
    %% 运行参数类
    properties
        %>飞行次数
        noFly
        %>超电子数量
        superElecs
        %>超电子电荷
        superElecCharge
        %>初始温度
        initTemp
        %>初始掺杂浓度
        initDopDen
        %>初始生成能谷
        initValley
        %>输入电场
        eFieldInput
        %>初始位置
        initPosition
        %>计算核数
        localWorkers
        %>nDot修正参数
        xsfornDot
        %>SourceB修正参数
        xsforSourceB
        %>模型尺寸参数
        d1
        d2
        d3
        d4
        d5
        %>模型长度
        mLength
        %>模型宽度
        mWidth
        %>感生电场长宽
        sczLength
        sczWidth
        %感生电场修正系数
        xsforInduce
        %>感生电场区域及下标
        indRegion
        induceEl
        induceEr
        induceEt
        induceEb
        %>noFly并行索引
        parGrid
        %>电子存储文件指针
        elog
        %>声子存储文件指针
        plog
        %>存储文件路径
        filePath
        %>文件下标
        fileIndex
    end
    
    methods
        function obj = ConfigureConstants
            %>构造函数
            obj.localWorkers = 20;
            obj.initTemp = 300;
            obj.mLength = 1;
            obj.mWidth = 1;
            obj.NX = 1;
            obj.NY = 1;
            obj.NW = 10;
            obj.elog = 0;
            obj.plog = 0;
            obj.fileIndex = 0;
            obj.initPosition = [0 0 0 0];
        end
        
        function updateConfigureConstants(obj)
            %>更新被动参数
            if isscalar(obj.d5)
                obj.mLength = obj.d1 + obj.d2 + obj.d3 + obj.d4 + obj.d5;
            elseif isscalar(obj.d1)
                obj.mLength = obj.d1 + obj.d2 + obj.d3;
            end
            obj.parGrid = linspace(0, obj.noFly, obj.localWorkers+1);
        end
        
    end
    
    methods
        generateElectricField(obj, dt, N, type, minTemp, maxTemp)
        modelMeshingAndReadData(obj, pc)
    end
    
end
