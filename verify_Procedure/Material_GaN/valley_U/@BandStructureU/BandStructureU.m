classdef BandStructureU < BandStructureForValley
    %% U能谷
    methods
        function obj = BandStructureU(pc)
            %>构造函数
            obj.Eg = pc.EgU;
            obj.mt = pc.mtU;
            obj.ml = pc.mlU;
            obj.alpha = pc.alphaU;
            obj.centerRatio = pc.centerRatioU;
            obj.md = (obj.mt^2*obj.ml)^(1/3);
            obj.Tz = [sqrt(pc.m / obj.mt)    0   0;
                        0   sqrt(pc.m / obj.mt)  0;
                        0   0   sqrt(pc.m / obj.ml)];
            obj.invTz = inv(obj.Tz);
        end
        
    end
end