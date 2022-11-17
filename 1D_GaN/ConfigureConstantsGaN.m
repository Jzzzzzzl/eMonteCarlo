classdef ConfigureConstantsGaN < ConfigureConstants
    %% 运行参数类
    methods
        function obj = ConfigureConstantsGaN(pc)
            %>构造函数
            obj.superElecs = 6000;
            obj.noFly = 33000;%0.0032
            
            obj.NX = 300;%>最好能整除所使用核数
            obj.NY = 1;
            obj.NA = 200;%>一维默认为2
            obj.NW = 200;%>最好能整除所使用核数
            obj.NE = 100;
            obj.initPosition = [0 3 0 100]*1e-9;
            obj.localWorkers = 20;
            obj.initValley = 11;
            %>温度场迭代
%             load teff.mat
%             obj.initTemp = teff;
            %>用于调节声子分布函数
            obj.xsforQ = 50;
            %>用于调节扩散温度
            obj.xsforSourceB = 850e19;
            %>用于调节左端发热量
            obj.initEnergy = 0.07*obj.e;
            %>沟道后能量弛豫长度
            obj.relaxLenCH = 150e-9;
            obj.minproba = 0.1;%>用于抑制电声散射
            obj.maxproba = 1.0;
            %>用于生成Peltier效应
            obj.energyPBmax = 0.0*obj.e;%>2D必须为0,GaN不需要该修正
            obj.relaxLenPB = 20e-9;
            obj.scatypePB = [4 6 8 10];
            %>模型所需变量
            obj.d1 = 100e-9;
            obj.d2 = 100e-9;
            obj.d3 = 200e-9;
            obj.mWidth = 100e-9;
            
            obj.modelMeshingAndReadData(pc);
            obj.filePath = '/home/jiang/documents/eMdatas/epDatas/';
        end
    end
    
end
