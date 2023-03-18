classdef ConfigureConstants < Data2ColocatedField
    %% 运行参数父类
    properties
        %>超电子数量
        superElecs
        %>飞行次数
        noFly
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
        %>电子初始位置
        staPosition
        %>电子生成位置
        initPosition
        %>计算核数
        localWorkers
        %>电场缩放因子
        xEScale
        yEScale
        %>速度修正参数
        vxScale
        vyScale
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
        %>模型长度
        mLength
        %>模型宽度
        mWidth
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
            obj.initTemp = 300;
            obj.initValley = 1;
            obj.initEnergy = 0.01*obj.e;
            obj.eFieldInput = [1, 0];
            obj.staPosition = [0 0 0 0];
            obj.initPosition = [0 0 0 0];
            obj.localWorkers = 4;
            obj.xEScale = 1;
            obj.yEScale = 1;
            obj.vxScale = 1;
            obj.vyScale = 1;
            obj.xsforQ = 1;
            obj.xsforSourceB = 1;
            obj.mLength = 5;
            obj.mWidth = 1;
            obj.energyPBmax = 0;
            obj.relaxLenPB = 0;
            obj.minproba = 1;
            obj.maxproba = 1;
            obj.relaxLenCH = 0;
            obj.NX = 1;
            obj.NY = 1;
            obj.NA = 2;
            obj.NW = 200;
            obj.NE = 200;
            obj.elog = 0;
            obj.plog = 0;
            obj.fileIndex = 0;
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
