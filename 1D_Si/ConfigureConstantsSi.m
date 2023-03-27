classdef ConfigureConstantsSi < ConfigureConstants
    %% 运行参数类
    methods
        function obj = ConfigureConstantsSi(pc)
            %>构造函数
            obj.superElecs = 200;
            obj.noFly = 10000;
            
            obj.NX = 200;
            obj.NY = 1;
            obj.NA = 200;
            obj.NW = 200;
            obj.NE = 1000;
            obj.initPosition = [0 1 0 100]*1e-9;
            obj.staPosition = [0 320 0 100]*1e-9;
            obj.localWorkers = 20;
            obj.initValley = 1;
            %>温度场迭代
%             load teff.mat
%             obj.initTemp = teff;
            %>用于调节电子飞行速度
            obj.vxScale = 1;
            obj.vyScale = 1;
            %>用于调节电场强度
            obj.xEScale = 1;
            obj.yEScale = 1;
            %>用于调节焦耳发热量，必须清空变量重新读取声子信息！！！
            obj.xsforQ = 105;
            %>用于调节峰值扩散温度，必须清空变量重新读取声子信息！！！
            obj.xsforSourceB = 10.2e18;
            %>用于调节左端发热量
            obj.initEnergy = 0.05*obj.e;
            %>沟道后能量弛豫长度
            obj.relaxLenCH = 100e-9;
            obj.minproba = 0.5;
            obj.maxproba = 0.8;
            %>用于生成Peltier效应
            obj.energyPBmax = 0.05*obj.e;
            obj.relaxLenPB = 20e-9;
            obj.scatypePB = [1 2 3 4 5 6 9 10 11];
            %>模型所需变量
            obj.d1 = 150e-9;
            obj.d2 = 20e-9;
            obj.d3 = 150e-9;
            obj.mWidth = 100e-9;
            
            obj.modelMeshingAndReadData(pc);
            obj.filePath = '/home/jiang/documents/eMdatas/epDatas/';
%             obj.filePath = '/run/media/root/姜竹林的移动硬盘/模拟数据/Si/320nm_1V_8000x10000_241_777/';
        end
    end
    
end