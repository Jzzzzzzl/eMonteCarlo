classdef StaggeredField < handle
    %% 交叉网格物理场
    properties
        datax
        datay
        leftx
        rightx
        topx
        bottomx
        lefty
        righty
        topy
        bottomy
    end
    
    methods
        function obj = StaggeredField(mm, initiaValue1, initiaValue2)
            %>构造函数
            obj.datax = zeros(mm.NX + 1, mm.NY + 2);
            obj.datay = zeros(mm.NX + 2, mm.NY + 1);
            obj.leftx = zeros(mm.NY + 2, 2);
            obj.rightx = zeros(mm.NY + 2, 2);
            obj.topx = zeros(mm.NX + 1, 2);
            obj.bottomx = zeros(mm.NX + 1, 2);
            obj.lefty = zeros(mm.NY + 1, 2);
            obj.righty = zeros(mm.NY + 1, 2);
            obj.topy = zeros(mm.NX + 2, 2);
            obj.bottomy = zeros(mm.NX + 2, 2);
            if nargin == 3
                obj.initializeDataValue(mm, initiaValue1, initiaValue2);
            end
        end
        
    end
    
    methods
        plotField(obj, mm)
        plotVectorField(obj, mm)
        computeDivergence(obj, mm, divU)
        initializeDataValue(obj, mm, initiaValue1, initiaValue2)
    end
end