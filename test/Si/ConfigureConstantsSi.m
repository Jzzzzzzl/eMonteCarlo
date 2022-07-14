classdef ConfigureConstantsSi < ConfigureConstants
    %% 运行参数类
    methods
        function obj = ConfigureConstantsSi(pc)
            obj.superElecs = 400;
            obj.noFly = 3000;
            obj.eFieldInput = [1, -100e5];
%             obj.eFieldInput = [4e-12 -1e5
%                                     1 -100e5];
%             obj.generateElectricField(5, 10, 'log', 5, 7);
            
            obj.initTemp = 300;
            obj.NE = 1000;
            obj.NW = 200;
            obj.initValley = 1;
            obj.localWorkers = 20;
            obj.initPosition = [0 0 0 0];
            obj.initEnergy = 0.0*obj.e;
            obj.initDopDen = 1e23;%不同掺杂浓度可能引起最大散射率的变化
            obj.modelMeshingAndReadData(pc);
            obj.filePath = '/home/jiang/documents/eMdatas/epDatas/';
        end
    end
    
end