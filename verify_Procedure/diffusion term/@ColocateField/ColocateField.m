classdef ColocateField < ModelMeshing
    %% 
    properties
        data
        left
        right
        top
        bottom
    end
    
    methods
        function obj = ColocateField(mm)
            if mm.NY == 0
                obj.data = zeros(mm.NX + 2, 1);
                obj.left = zeros(1, 1);
                obj.right = zeros(1, 1);
            else
                obj.data = zeros(mm.NX + 2, mm.NY + 2);
                obj.left = zeros(mm.NY + 2, 1);
                obj.right = zeros(mm.NY + 2, 1);
                obj.top = zeros(mm.NX + 2, 1);
                obj.bottom = zeros(mm.NX + 2, 1);
            end
        end
        
    end
end