classdef BandStructure < handle
    
    properties
        
        
        
    end
    
    
    methods
        
        function obj = BandStructure(Material, pc)
            %能带曲线
            if strcmpi(Material, "Si")
                
            elseif strcmpi(Material, "GaN")
                
            end
        end
        
        function [es] = GenerateEllipsoid(obj, es, pc, cc)
            % 
            
            n = 10; %椭球点密集程度
            energy0 = es.energy/cc.inParabolicFactor;
            rx = real(sqrt(2 * energy0 * pc.mt) / pc.hbar);
            ry = real(sqrt(2 * energy0 * pc.mt) / pc.hbar);
            rz = real(sqrt(2 * energy0 * pc.ml) / pc.hbar);
            [x1, y1, z1] = ellipsoid(0,0,0,rx,ry,rz,n);
            
            while true
                randx = round(rand(1)*(n - 1)) + 1;
                randy = round(rand(1)*(n - 1)) + 1;
                x = x1(randx, randy);
                y = y1(randx, randy);
                z = z1(randx, randy);
                kk = [x, y, z] + [0, 0,  0.85] * dGX;
                switch es.valley
                    case 1
                        es.k = kk*RotMatrix(-pi/2, 'y');
                    case -1
                        es.k = kk*RotMatrix(pi/2, 'y');
                    case 2
                        es.k = kk*RotMatrix(pi/2, 'x');
                    case -2
                        es.k = kk*RotMatrix(-pi/2, 'x');
                    case 3
                        es.k = kk*RotMatrix(0, 'x');
                    case -3
                        es.k = kk*RotMatrix(-pi, 'x');
                end
                if double(max(abs(es.k))/dGX) < 1.0
                    break;
                end
            end

        end
        
    end
    
    
end