classdef ConfigureConstantsSi < ConfigureConstants
    %% 运行参数类
    methods
        function obj = ConfigureConstantsSi(pc)
            obj.superElecs = 100;
            obj.noFly = 4000;%0.025ps/次飞行
%             obj.eFieldInput = [1, -10e5];
%             obj.eFieldInput = [4e-12 -1e5
%                                     1 -100e5];
            obj.generateElectricField(5, 20, 'log', 5, 7);
            
            obj.NW = 100;
            obj.initValley = 1;
            obj.initPosition = [0 0 0 0];
            obj.initDopDen = 1e23;
            obj.modelMeshingAndReadData(pc);
            obj.filePath = '/home/jiang/documents/eMdatas/epDatas/';
        end
    end
    
end
