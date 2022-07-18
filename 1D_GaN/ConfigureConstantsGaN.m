classdef ConfigureConstantsGaN < ConfigureConstants
    %% 运行参数类
    methods
        function obj = ConfigureConstantsGaN(pc)
            %>构造函数
            obj.superElecs = 1000;
            obj.noFly = 40000;
            
            obj.NX = 500;%>最好能整除所使用核数
            obj.NY = 1;
            obj.NA = 200;%>一维默认为2
            obj.NW = 200;%>最好能整除所使用核数
            obj.NE = 100;
            obj.initPosition = [0 3 0 100]*1e-9;
            obj.localWorkers = 20;
            obj.initValley = 11;
            %>用于调节声子分布函数
            obj.xsforQ = 10;
            %>用于调节扩散温度
            obj.xsforSourceB = 250e18;
            %>用于调节左端发热量
            obj.initEnergy = 0.03*obj.e;
            %>沟道后能量弛豫长度
            obj.relaxLenCH = 10e-9;
            obj.minproba = 1.0;
            obj.maxproba = 1.0;
            %>用于生成Peltier效应
            obj.energyPBmax = 0.6*obj.e;
            obj.relaxLenPB = 50e-9;
            obj.scatypePB = [4 6 8 10];
            %>模型所需变量
            obj.d1 = 200e-9;
            obj.d2 = 200e-9;
            obj.d3 = 200e-9;
            obj.mWidth = 100e-9;
            
            obj.modelMeshingAndReadData(pc);
            obj.filePath = '/home/jiang/documents/eMdatas/epDatas/';
        end
    end
    
end
