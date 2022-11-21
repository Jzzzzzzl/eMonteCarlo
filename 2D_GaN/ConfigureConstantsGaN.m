classdef ConfigureConstantsGaN < ConfigureConstants
    %% 运行参数类
    methods
        function obj = ConfigureConstantsGaN(pc)
            %>构造函数
            obj.superElecs = 60;
            obj.noFly = 3000;%0.0045ps/次飞行
            
            obj.NX = 60;
            obj.NY = 30;
            obj.NA = 200;
            obj.NW = 200;
            obj.NE = 1000;
            obj.initPosition = [3000 3050 9 10]*1e-9;
            obj.staPosition = [3000 9000 9 10]*1e-9;
            obj.localWorkers = 20;
            obj.initValley = 11;
            %>温度场迭代
%             load teff.mat
%             obj.initTemp = teff;
            %>用于调节电子飞行速度
            obj.vxScale = 10;
            obj.vyScale = 1;
            %>用于调节电场强度
            obj.xEScale = 1;
            obj.yEScale = 0.01;
            %>用于调节焦耳发热量
            obj.xsforQ = 100;
            %>用于调节峰值扩散温度
            obj.xsforSourceB = 240e19;
            %>用于调节左端发热量
            obj.initEnergy = 0.01*obj.e;
            %>热点后能量弛豫长度
            obj.relaxLenCH = 5000e-9;
            obj.minproba = 0.3;
            obj.maxproba = 1.0;
            %>热点前能量弛豫长度
            obj.relaxLenPB = 50e-9;
            %>模型所需变量
            obj.d1 = 550e-9;
            obj.d2 = 950e-9;
            obj.d3 = 3000e-9;
            obj.d4 = 5000e-9;
            obj.d5 = 500e-9;
            obj.mWidth = 10e-9;
            
            obj.modelMeshingAndReadData(pc);
            obj.filePath = '/home/jiang/documents/eMdatas/epDatas/';
        end
    end
    
end