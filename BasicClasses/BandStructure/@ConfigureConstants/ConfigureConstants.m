classdef ConfigureConstants < Data2ColocatedField
    %% 运行参数父类
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
        %>初始电子能量
        initEnergy
        %>时间阶跃电场
        eFieldInput
        %>初始电子位置
        initPosition
        %>计算核数
        localWorkers
        %>Q修正参数
        xsforQ
        %>SourceB修正参数
        xsforSourceB
        %>模型尺寸参数
        d1
        d2
        d3
        d4
        d5
        %>最大势垒能量差
        energyPBmax
        %>势垒能量索引表
        energyPB
        %>势垒能量弛豫长度
        relaxLenPB
        %>发生散射概率函数
        scatProba
        %>发生散射最小概率
        minproba
        %>发生散射最大概率
        maxproba
        %>沟道后能量弛豫长度
        relaxLenCH
        %>势垒区散射类型
        scatypePB
        %>势垒区坐标
        regionPB
        %>沟道区坐标
        regionCH
        %>模型长度
        mLength
        %>模型宽度
        mWidth
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
            obj.relaxLenPB = 0;
            obj.relaxLenCH = 0;
            obj.minproba = 1;
            obj.maxproba = 1;
            obj.localWorkers = 20;
            obj.initTemp = 300;
            obj.mLength = 1;
            obj.mWidth = 1;
            obj.NX = 1;
            obj.NY = 1;
            obj.NA = 2;
            obj.NW = 10;
            obj.elog = 0;
            obj.plog = 0;
            obj.fileIndex = 0;
            obj.initPosition = [0 0 0 0];
        end
    end
    
    methods
        getFileID(obj, index)
        writeTCADtoFile(obj)
        assignJobsForParallel(obj)
        updateConfigureConstants(obj)
        modelMeshingAndReadData(obj, pc)
        generateElectricField(obj, dt, N, type, minTemp, maxTemp)
    end
    
end
