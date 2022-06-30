classdef ColocateField < handle
    %% 正交网格物理场
    properties
        data
        datax
        datay
        left
        right
        top
        bottom
    end
    
    methods
        function obj = ColocateField(mm, initiaValue)
            %>构造函数
            obj.data = zeros(mm.NX + 2, mm.NY + 2);
            obj.datax = zeros(mm.NX + 2, mm.NY + 2);
            obj.datay = zeros(mm.NX + 2, mm.NY + 2);
            obj.left = zeros(mm.NY + 2, 2);
            obj.right = zeros(mm.NY + 2, 2);
            obj.top = zeros(mm.NX + 2, 2);
            obj.bottom = zeros(mm.NX + 2, 2);
            if nargin == 2
                obj.initializeDataValue(mm, initiaValue);
            end
        end
        
    end
    
    methods
        plotField(obj, mm, ~)
        initializeDataValue(obj, mm, initiaValue)
    end
end