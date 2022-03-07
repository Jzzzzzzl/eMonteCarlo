classdef ModelMeshing < handle
    
    properties
        frequency
        energy
        modelx
        modely
        time
        NW
        NE
        NX
        NY
        Nt
    end
    
    methods
        
        function obj = ModelMeshing
            %
            
            
            
        end
        
        function FrequencyGrid(obj, wMin, wMax, N)
            %生成频率网格
            
            obj.NW = N;
            obj.frequency = GridClass(wMin, wMax, N);
            
        end
        
        function EnergyGrid(obj, eMin, eMax, N)
            %生成能量网格
            
            obj.NE = N;
            obj.energy = GridClass(eMin, eMax, N);
            
        end
        
        function ModelXGrid(obj, xMin, xMax, N)
            %生成x方向网格
            
            obj.NX = N;
            obj.modelx = GridClass(xMin, xMax, N);
            
        end
        
        function ModelYGrid(obj, yMin, yMax, N)
            %生成x方向网格
            
            obj.NY = N;
            obj.modely = GridClass(yMin, yMax, N);
            
        end
        
        function TimeGrid(obj, tMin, tMax, N)
            %生成频率网格
            
            obj.Nt = N;
            obj.time = GridClass(tMin, tMax, N);
            
        end
        
        
        
    end
end