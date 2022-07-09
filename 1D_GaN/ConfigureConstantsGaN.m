classdef ConfigureConstantsGaN < ConfigureConstants
    %% 运行参数类
    methods
        function obj = ConfigureConstantsGaN(pc)
            %>构造函数
            obj.superElecs = 100;
            obj.noFly = 10000;
            
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
            obj.initEnergy = 0.06*obj.e;
            %>用于生成Peltier效应
            obj.energyPBmax = 0.19*obj.e;
            obj.relaxLenPB = 20e-9;
            obj.scatypePB = [1 2 3 4 5 6 9 10 11];
            %>模型所需变量
            obj.d1 = 100e-9;
            obj.d2 = 100e-9;
            obj.d3 = 100e-9;
            obj.mWidth = 100e-9;
            
            obj.modelMeshingAndReadData(pc);
            obj.filePath = '/home/jiang/documents/eMdatas/epDatas/';
        end
    end
    
end
