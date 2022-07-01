classdef ConfigureConstants < Data2ColocatedField
    %% 运行参数类
    properties
        %>飞行次数
        noFly
        %>超电子数量
        superElecs
        %>常数飞行时间
        dtConst
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
        %>势垒区半宽
        hwoPBR
        %>势垒能量差
        energyPB
        %>势垒区坐标
        regionPB
        %>沟道区坐标
        regionCH
        %>模型长度
        mLength
        %>模型宽度
        mWidth
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
        %>结构区域并行任务索引
        pjobIndexs
        %>频率区域并行任务索引
        fjobIndexs
        %>电子ID并行任务索引
        ejobIndexs
    end
    
    methods
        function obj = ConfigureConstants
            %>构造函数
            obj.dtConst = 0;
            obj.energyPB = 0*obj.e;
            obj.localWorkers = 20;
            obj.initTemp = 300;
            obj.mLength = 1;
            obj.mWidth = 1;
            obj.hwoPBR = 0;
            obj.NX = 1;
            obj.NY = 1;
            obj.NA = 2;
            obj.NW = 10;
            obj.elog = 0;
            obj.plog = 0;
            obj.fileIndex = 0;
            obj.initPosition = [0 0 0 0];
        end
        
        function updateConfigureConstants(obj)
            %>更新被动参数
            %>模型长度计算
            if isscalar(obj.d5)
                obj.mLength = obj.d1 + obj.d2 + obj.d3 + obj.d4 + obj.d5;
            elseif isscalar(obj.d1)
                obj.mLength = obj.d1 + obj.d2 + obj.d3;
            end
            %>用于getFileID函数
            obj.parGrid = linspace(0, obj.noFly, obj.localWorkers+1);
            %>势垒/沟道区域坐标
            if obj.hwoPBR ~= 0
                if obj.NY == 1
                    obj.regionPB = [(obj.d1-obj.hwoPBR) (obj.d1+obj.hwoPBR) 1 -1];
                    obj.regionCH = [(obj.d1+obj.hwoPBR) (obj.d1+obj.d2) 1 -1];
                else
                    disp("二维情况，暂未考虑！");
                end
            else
                obj.regionPB = [0 0 0 0];
                obj.regionCH = [0 0 0 0];
            end
            %>并行任务坐标划分
            obj.assignJobsForParallel;
        end
    end
    
    methods
        getFileID(obj, k)
        assignJobsForParallel(obj)
        modelMeshingAndReadData(obj, pc)
        generateElectricField(obj, dt, N, type, minTemp, maxTemp)
    end
    
end
