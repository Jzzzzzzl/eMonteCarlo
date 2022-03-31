classdef BandStructureGammaX < BandStructureForValley
    %% GammaX能谷
    methods
        function obj = BandStructureGammaX(pc)
            %>构造函数
            obj.Eg = pc.EgGX;
            obj.mt = pc.mtGX;
            obj.ml = pc.mlGX;
            obj.alpha = pc.alphaGX;
            obj.centerRatio = pc.centerRatioGX;
            obj.md = (obj.mt^2*obj.ml)^(1/3);
            obj.Tz = [sqrt(pc.m / obj.mt)    0   0;
                        0   sqrt(pc.m / obj.mt)  0;
                        0   0   sqrt(pc.m / obj.ml)];
            obj.invTz = inv(obj.Tz);
        end
        
    end
end