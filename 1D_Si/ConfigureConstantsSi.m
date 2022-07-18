classdef ConfigureConstantsSi < ConfigureConstants
    %% 运行参数类
    methods
        function obj = ConfigureConstantsSi(pc)
            %>构造函数
            obj.superElecs = 4000;
            obj.noFly = 20000;
            
            obj.NX = 500;%>最好能整除所使用核数
            obj.NY = 1;
            obj.NA = 200;%>一维默认为2
            obj.NW = 200;%>最好能整除所使用核数
            obj.NE = 1000;
            obj.initPosition = [0 3 0 100]*1e-9;
            obj.localWorkers = 20;
            obj.initValley = 1;
            %>温度场迭代
%             load teff.mat
%             obj.initTemp = teff;
            %>用于调节声子分布函数
            obj.xsforQ = 170;
            %>用于调节扩散温度
            obj.xsforSourceB = 40e18;
            %>用于调节左端发热量
            obj.initEnergy = 0.05*obj.e;
            %>沟道后能量弛豫长度
            obj.relaxLenCH = 100e-9;
            obj.minproba = 1.0;
            obj.maxproba = 1.0;
            %>用于生成Peltier效应
            obj.energyPBmax = 0.1*obj.e;
            obj.relaxLenPB = 20e-9;
            obj.scatypePB = [1 2 3 4 5 6 9 10 11];
            %>模型所需变量
            obj.d1 = 150e-9;
            obj.d2 = 20e-9;
            obj.d3 = 150e-9;
            obj.mWidth = 100e-9;
            
            obj.modelMeshingAndReadData(pc);
            obj.filePath = '/home/jiang/documents/eMdatas/epDatas/';
        end
    end
    
end