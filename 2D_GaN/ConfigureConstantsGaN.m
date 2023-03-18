classdef ConfigureConstantsGaN < ConfigureConstants
    %% 运行参数类
    methods
        function obj = ConfigureConstantsGaN(pc)
            %>构造函数
            obj.superElecs = 400;
            obj.noFly = 600;%0.0045ps/次飞行
            
            obj.NX = 40;
            obj.NY = 30;
            obj.NA = 200;
            obj.NW = 200;
            obj.NE = 1000;
            obj.initPosition = [3000 3010 9 10]*1e-9;
            obj.staPosition = [3000 9000 9 10]*1e-9;
            obj.localWorkers = 20;
            obj.initValley = 11;
            %>模型所需变量
            obj.d1 = 500e-9;
            obj.d2 = 1000e-9;
            obj.d3 = 500e-9;
            obj.d4 = 7500e-9;
            obj.d5 = 500e-9;
            obj.mWidth = 10e-9;
            %>温度场迭代
%             load teff.mat
%             obj.initTemp = teff;
            %>用于调节电子飞行速度
            obj.vxScale = 20;
            obj.vyScale = 1;
            %>用于调节电场强度
            obj.xEScale = 1.0;
            obj.yEScale = 0.001;
            %>用于调节焦耳发热量
            obj.xsforQ = 60;
            %>用于调节峰值扩散温度
            obj.xsforSourceB = 100e18;
            %>用于调节左端发热量
            obj.initEnergy = 0.01*obj.e;
            %>热点后能量弛豫长度
            obj.relaxLenCH = 1000e-9;
            obj.minproba = 0.5;
            obj.maxproba = 1.0;
            %>热点前能量弛豫长度
            obj.relaxLenPB = 500e-9;
            
            obj.modelMeshingAndReadData(pc);
            obj.filePath = '/home/jiang/documents/eMdatas/epDatas/';
            
        end
    end
    
end