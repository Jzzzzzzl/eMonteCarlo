classdef ConfigureConstantsGaN < ConfigureConstants
    %% 运行参数类
    methods
        function obj = ConfigureConstantsGaN(pc)
            obj.superElecs = 20;
            obj.noFly = 5500;%0.004ps/次飞行
%             obj.eFieldInput = [1, -1.0e6];
%             obj.eFieldInput = [1.0e-12 -4.0e7
%                                     1         -1.0e5];
            obj.generateElectricField(3, 7, 'log', 5, 8);
            
            obj.NW = 100;
            obj.initValley = 11;
            obj.initPosition = [0 0 0 0];
            obj.initDopDen = 1e23;
            obj.modelMeshingAndReadData(pc);
            obj.filePath = '/home/jiang/documents/eMdatas/epDatas/';
        end
        
    end
end
     