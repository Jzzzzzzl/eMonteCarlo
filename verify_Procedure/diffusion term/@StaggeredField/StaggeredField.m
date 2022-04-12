classdef StaggeredField < handle
    %% 
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
        function obj = StaggeredField(mm)
            if mm.NY == 0
                obj.datax = zeros(mm.NX + 1, 1);
            else
                obj.datax = zeros(mm.NX + 1, mm.NY + 2);
                obj.datay = zeros(mm.NX + 2, mm.NY + 1);
            end
        end
        
        function [divdata] = computeDivergence(obj, mm)
            divdata = zeros(mm.NX, mm.NY);
            for i = 1 : mm.NX
                deltax = mm.modelx.face(i + 1) - mm.modelx.face(i);
                for j = 1 : mm.NY
                    deltay = mm.modely.face(j + 1) - mm.modely.face(j);
                    temp = 0;
                    temp = temp + (obj.datax(i + 1, j) - obj.datax(i, j)) * deltay;
                    temp = temp + (obj.datay(i, j + 1) - obj.datay(i, j)) * deltax;
                    divdata(i, j) = temp / (deltax * deltay);
                end
            end
            plot(divdata)
        end
        
        function plotFieldX(obj, mm)
            X = mm.modelx.face;
            Y = mm.modely.point;
            Z = obj.datax';
            figure
            mesh(X, Y, Z)
        end
        
        function plotFieldY(obj, mm)
            X = mm.modelx.point;
            Y = mm.modely.face;
            Z = obj.datay';
            figure
            mesh(X, Y, Z)
        end
        
        function plotVectorField(obj, mm)
            if mm.NX ~= mm.NY
                error("只有NX == NY时才能画矢量图！")
            end
            X = mm.modelx.point;
            Y = mm.modely.face;
            figure
            quiver(X, Y, obj.datax, obj.datay')
        end
    end
end