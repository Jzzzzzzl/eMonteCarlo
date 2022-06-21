classdef ModelMeshing < handle
    %% 本文件提供网格划分类
    %> 若为一维模型，则NY = 1，实际按二维进行计算
    properties(Constant)
        e = 1.602176634e-19;
        m = 9.10956e-31;
        kb = 1.380649e-23;
        h = 6.6260755e-34;
        hbar = 1.05457266e-34;
        epsilon0 = 8.854187817e-12;
    end
    
    properties
        frequency
        vector
        energy
        modelx
        modely
        angle
        time
    end
    
    properties
        NW
        NQ
        NE
        NX
        NY
        Nt
        NA
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
        
        function waveVectorGrid(obj, qMin, qMax, N)
            %>生成波矢网格
            obj.NQ = N;
            obj.vector = obj.meshGrid(obj.frequency, qMin, qMax, N);
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
        
        function angleGrid(obj, gMin, gMax, N)
            %>生成角度网格
            obj.NA = N;
            obj.angle = obj.meshGrid(obj.angle, gMin, gMax, N);
            if obj.NA == 2
                obj.angle.point(2:end-1) = obj.angle.point(2:end-1) - pi/2;
            end
        end
        
    end
    methods
        meshPlot(obj)
    end
    methods(Static)
        [grid] = meshGrid(grid, min, max, N, ratio, layerNum)
    end
end