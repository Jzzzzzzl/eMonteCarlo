classdef ConfigureConstantsSi < ConfigureConstants
    %% 运行参数类
    methods
        function obj = ConfigureConstantsSi(pc)
            %>构造函数
            obj.superElecs = 1000;
            obj.noFly = 20000;
            
            obj.NX = 80;%>最好能整除所使用核数
            obj.NY = 40;
            obj.NA = 200;%>一维默认为2
            obj.NW = 200;%>最好能整除所使用核数
            obj.NE = 1000;
            obj.initPosition = [110 115 190 200]*1e-9;%>起始点远离电子高浓度区
            obj.localWorkers = 20;
            obj.initValley = 1;
            %>温度场迭代
%             load teff.mat
%             obj.initTemp = teff;
            %>用于调节声子分布函数
            obj.xsforQ = 8.5;
            %>用于调节扩散温度
            obj.xsforSourceB = 150e19;
            %>用于调节左端发热量
            obj.initEnergy = 0.001*obj.e;
            %>热点后能量弛豫长度
            obj.relaxLenCH = 30e-9;
            obj.minproba = 1.0;
            obj.maxproba = 1.0;
            %>热点前能量弛豫长度
            obj.relaxLenPB = 50e-9;
            %>模型所需变量
            obj.d1 = 100e-9;
            obj.d2 = 0e-9;
            obj.d3 = 300e-9;
            obj.d4 = 0e-9;
            obj.d5 = 100e-9;
            obj.mWidth = 200e-9;
            
            obj.modelMeshingAndReadData(pc);
            obj.filePath = '/home/jiang/documents/eMdatas/epDatas/';
        end
    end
    
end