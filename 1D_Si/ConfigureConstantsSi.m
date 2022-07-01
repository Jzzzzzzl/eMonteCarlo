classdef ConfigureConstantsSi < ConfigureConstants
    %% 运行参数类
    methods
        function obj = ConfigureConstantsSi(pc)
            %>构造函数
            obj.superElecs = 500;
            obj.noFly = 10000;
            obj.dtConst = 1e-15;
            obj.hwoPBR = 5e-9;
            obj.energyPB = 0.1*obj.e;
            
            obj.NX = 320;%>最好能整除所使用核数
            obj.NY = 1;
            obj.NA = 2;%>一维默认为2
            obj.NW = 200;%>最好能整除所使用核数
            obj.NE = 100;
            obj.localWorkers = 20;
            obj.initValley = 1;
            obj.xsfornDot = 10;
            obj.xsforSourceB = 8e19;
            obj.initPosition = [0 5 0 100]*1e-9;
            obj.scatypePB = [1 2 3 4 5 10 11];
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