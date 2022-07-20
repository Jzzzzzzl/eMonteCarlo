classdef ConfigureConstantsGaN < ConfigureConstants
    %% 运行参数类
    methods
        function obj = ConfigureConstantsGaN(pc)
            obj.superElecs = 1000;
            obj.noFly = 2500;%0.004ps/次飞行
            obj.eFieldInput = [1, -6e7];
%             obj.eFieldInput = [5.0e-12 -6.0e7
%                                     1         -5.0e5];
%             obj.generateElectricField(5, 12, 'lin', 1e7, 6e7);
            
            obj.initTemp = 300;
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