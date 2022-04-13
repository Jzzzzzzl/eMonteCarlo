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
        function obj = ColocateField(mm, initiaValue)
            if mm.NY == 0
                obj.data = zeros(mm.NX + 2, 1);
                obj.left = zeros(1, 2);
                obj.right = zeros(1, 2);
            else
                obj.data = zeros(mm.NX + 2, mm.NY + 2);
                obj.left = zeros(mm.NY + 2, 2);
                obj.right = zeros(mm.NY + 2, 2);
                obj.top = zeros(mm.NX + 2, 2);
                obj.bottom = zeros(mm.NX + 2, 2);
            end
            if nargin == 2
                obj.initializeDataValue(mm, initiaValue);
            end
        end
        
        function initializeDataValue(obj, mm, initiaValue)
            %>
            if mm.NY == 0
                for i = 1 : mm.NX+2
                    obj.data(i) = initiaValue;
                end
            else
                for i = 1 : mm.NX+2
                    for j = 1 : mm.NY+2
                        obj.data(i, j) = initiaValue;
                    end
                end
            end
        end
        
        function plotField(obj, mm)
            %>
            X = mm.modelx.point(2:end-1);
            Y = mm.modely.point(2:end-1);
            Z = zeros(mm.NY, mm.NX);
            for i = 1 : mm.NY
                for j = 1 : mm.NX
                    Z(i, j) = obj.data(j+1, i+1);
                end
            end
            figure
            slg = pcolor(X, Y, Z);
            slg.EdgeColor = 'interp';
            shading interp
            colormap(turbo)
        end
        
    end
end