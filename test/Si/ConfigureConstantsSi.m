classdef ConfigureConstantsSi < ConfigureConstants
    %% 运行参数类
    methods
        function obj = ConfigureConstantsSi(pc)
            obj.superElecs = 60;
            obj.noFly = 3000;%0.0185ps/次飞行
            obj.eFieldInput = [1, -1805320];
%             obj.eFieldInput = [50e-12 -1e5
%                                     1 -100e5];
%             obj.generateElectricField(5, 10, 'log', 5, 7);
            
            obj.NW = 200;
            obj.NE = 1000;
            obj.initPosition = [0 0 0 0];
            obj.staPosition = [0 0 0 0];
            obj.localWorkers = 20;
            obj.initValley = 1;
            obj.initTemp = 300;
            obj.initEnergy = 0.0*obj.e;
            obj.initDopDen = 1e23;
            
            obj.modelMeshingAndReadData(pc);
            obj.filePath = '/home/jiang/documents/eMdatas/epDatas/';
        end
    end
    
end