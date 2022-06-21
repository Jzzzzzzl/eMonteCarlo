classdef ConfigureConstantsSi < ConfigureConstants
    %% 运行参数类
    methods
        function obj = ConfigureConstantsSi(pc)
            %>构造函数
            obj.superElecs = 200;
            obj.noFly = 2000;%0.0029455
            
            obj.NX = 300;%>最好能整除所使用核数
            obj.NY = 1;
            obj.NA = 400;%>一维默认为2
            obj.NW = 200;%>最好能整除所使用核数
            obj.initValley = 1;
            obj.xsfornDot = 1;
            obj.xsforSourceB = 8e19;
            obj.initPosition = [295 300 0 100]*1e-9;
            %>模型所需变量
            obj.d1 = 100e-9;
            obj.d2 = 100e-9;
            obj.d3 = 100e-9;
            obj.mWidth = 100e-9;
            %>感生电场变量
            obj.sczLength = 20e-9;
            obj.xsforInduce = 0.0;
            obj.indRegion = [150 185]*1e-9;
            
            obj.modelMeshingAndReadData(pc);
            obj.filePath = '/home/jiang/documents/eMdatas/epDatas/';
        end
    end
    
end
