classdef BandStructureGammaX < BandStructureForValley
    %% GammaX能谷
    methods
        function obj = BandStructureGammaX(pc)
            %>构造函数
            obj.Eg = 0.0*pc.e;
            obj.mt = 0.196*pc.m;
            obj.ml = 0.916*pc.m;
            obj.alpha = 0.5;
            obj.centerRatio = 0.85;
            obj.md = (obj.mt^2*obj.ml)^(1/3);
            obj.Tz = [sqrt(pc.m / obj.mt)    0   0;
                        0   sqrt(pc.m / obj.mt)  0;
                        0   0   sqrt(pc.m / obj.ml)];
            obj.invTz = inv(obj.Tz);
        end
        
    end
end