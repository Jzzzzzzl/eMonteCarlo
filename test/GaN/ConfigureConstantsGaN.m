classdef ConfigureConstantsGaN < ConfigureConstants
    %% 运行参数类
    methods
        function obj = ConfigureConstantsGaN(pc)
            obj.superElecs = 1000;
            obj.noFly = 3000;%0.004ps/次飞行
            obj.eFieldInput = [1, -0.5e8];
%             obj.eFieldInput = [1.0e-12 -4.0e7
%                                     1         -1.0e5];
%             obj.generateElectricField(3, 10, 'log', 5, 8);
            
            obj.NE = 1000;
            obj.NW = 200;
            obj.initValley = 11;
            obj.localWorkers = 20;
            obj.initPosition = [0 0 0 0];
            obj.initEnergy = 0.0*obj.e;
            obj.initDopDen = 1e23;
            obj.modelMeshingAndReadData(pc);
            obj.filePath = '/home/jiang/documents/eMdatas/epDatas/';
        end
        
    end
end
     