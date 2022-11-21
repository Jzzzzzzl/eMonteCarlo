classdef ConfigureConstantsGaN < ConfigureConstants
    %% 运行参数类
    methods
        function obj = ConfigureConstantsGaN(pc)
            %>构造函数
            obj.superElecs = 60;
            obj.noFly = 3000;%0.0032
            
            obj.NX = 300;
            obj.NY = 1;
            obj.NA = 200;
            obj.NW = 200;
            obj.NE = 100;
            obj.initPosition = [0 3 0 100]*1e-9;
            obj.staPosition = [0 400 0 100]*1e-9;
            obj.localWorkers = 20;
            obj.initValley = 11;
            %>温度场迭代
%             load teff.mat
%             obj.initTemp = teff;
            %>用于调节电子飞行速度
            obj.vxScale = 1;
            obj.vyScale = 1;
            %>用于调节电场强度
            obj.xEScale = 1;
            obj.yEScale = 1;
            %>用于调节焦耳发热量
            obj.xsforQ = 50;
            %>用于调节峰值扩散温度
            obj.xsforSourceB = 850e19;
            %>用于调节左端发热量
            obj.initEnergy = 0.07*obj.e;
            %>沟道后能量弛豫长度
            obj.relaxLenCH = 150e-9;
            obj.minproba = 0.1;
            obj.maxproba = 1.0;
            %>用于生成Peltier效应
            obj.energyPBmax = 0.0*obj.e;
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
