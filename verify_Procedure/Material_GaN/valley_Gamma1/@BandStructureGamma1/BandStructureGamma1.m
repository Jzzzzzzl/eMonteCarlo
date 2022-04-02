classdef BandStructureGamma1 < BandStructureForValley
    %% U能谷
    methods
        function obj = BandStructureGamma1(pc)
            %>构造函数
            obj.Eg = pc.EgG1;
            obj.mt = pc.mtG1;
            obj.ml = pc.mlG1;
            obj.alpha = pc.alphaG1;
            obj.centerRatio = pc.centerRatioG1;
            obj.md = (obj.mt^2*obj.ml)^(1/3);
            obj.Tz = [sqrt(pc.m / obj.mt)    0   0;
                        0   sqrt(pc.m / obj.mt)  0;
                        0   0   sqrt(pc.m / obj.ml)];
            obj.invTz = inv(obj.Tz);
        end
        
    end
end
