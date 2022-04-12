classdef ModelMeshing < handle
    %% 本文件提供网格划分类
    % ======================================================================
    %>     包括的网格类型有：
    %> frequency/energy/modelx/modely/time
    properties
        frequency
        energy
        modelx
        modely
        time
    end
    properties
        NW
        NE
        NX
        NY
        Nt
    end
    
    methods
        
        function modelXGrid(obj, xMin, xMax, N, ratio, layerNum)
            %>生成x方向网格
            obj.NX = N;
            if nargin == 4
                obj.modelx = obj.meshGrid(obj.modelx, xMin, xMax, N);
            elseif nargin == 6
                obj.modelx = obj.meshGrid(obj.modelx, xMin, xMax, N, ratio, layerNum);
            end
        end
        
        function modelYGrid(obj, yMin, yMax, N, ratio, layerNum)
            %>生成y方向网格
            obj.NY = N;
            if nargin == 4
                obj.modely = obj.meshGrid(obj.modely, yMin, yMax, N);
            elseif nargin == 6
                obj.modely = obj.meshGrid(obj.modely, yMin, yMax, N, ratio, layerNum);
            end
        end
        
        function frequencyGrid(obj, wMin, wMax, N)
            %>生成频率网格
            obj.NW = N;
            obj.frequency = obj.meshGrid(obj.frequency, wMin, wMax, N);
        end
        
        function energyGrid(obj, eMin, eMax, N)
            %>生成能量网格
            obj.NE = N;
            obj.energy = obj.meshGrid(obj.energy, eMin, eMax, N);
        end
        
        function timeGrid(obj, tMin, tMax, N)
            %>生成时间网格
            obj.Nt = N;
            obj.time = obj.meshGrid(obj.time, tMin, tMax, N);
        end
        
    end
    methods
        modelMeshingGridPlot(obj)
    end
    methods(Static)
        [grid] = meshGrid(grid, min, max, N, ratio, layerNum)
    end
end