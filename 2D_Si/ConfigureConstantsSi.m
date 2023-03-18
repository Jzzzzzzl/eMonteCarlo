classdef ConfigureConstantsSi < ConfigureConstants
    %% 运行参数类
    methods
        function obj = ConfigureConstantsSi(pc)
            %>构造函数
            obj.superElecs = 2000;
            obj.noFly = 20000;%0.0083ps/次
            
            obj.NX = 80;
            obj.NY = 40;
            obj.NA = 200;
            obj.NW = 200;
            obj.NE = 1000;
            obj.initPosition = [110 115 190 200]*1e-9;
            obj.staPosition = [110 400 100 200]*1e-9;
            obj.localWorkers = 20;
            obj.initValley = 1;
            %>温度场迭代
%             load teff.mat
%             obj.initTemp = teff;
            %>用于调节电子飞行速度
            obj.vxScale = 5;
            obj.vyScale = 1;
            %>用于调节电场强度
            obj.xEScale = 1;
            obj.yEScale = 1;
            %>用于调节焦耳发热量
            obj.xsforQ = 8.9;
            %>用于调节扩散温度
            obj.xsforSourceB = 58e18;
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
%             obj.filePath = '/home/jiang/documents/eMdatas/epDatas/';
            obj.filePath = '/run/media/root/姜竹林的移动硬盘/模拟数据/第4章/Si_MOSFET_2000x20000_8.9_58/';
        end
    end
    
end