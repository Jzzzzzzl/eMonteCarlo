classdef DecideValleyKind < handle
    %% 能谷指向类
    properties
        bs
        sr
        sp
        bsU
        srU
        spU
        bsGamma1
        srGamma1
        spGamma1
        bsGamma3
        srGamma3
        spGamma3
    end
    
    methods
        function obj = DecideValleyKind(pc)
            %>构造函数
            obj.bsU = BandStructureU(pc);
            obj.srU = ScatterringRateTableU(pc);
            obj.spU = ScatterringProcessU;
            obj.bsGamma1 = BandStructureGamma1(pc);
            obj.srGamma1 = ScatterringRateTableGamma1(pc);
            obj.spGamma1 = ScatterringProcessGamma1;
            obj.bsGamma3 = BandStructureGamma3(pc);
            obj.srGamma3 = ScatterringRateTableGamma3(pc);
            obj.spGamma3 = ScatterringProcessGamma3;
        end
        
        function valleyGuidingPrinciple(obj, es)
            %>将dv指向电子所在能谷种类
            type = obj.judgeValleyKind(es);
            switch type
                case "U"
                    obj.bs = obj.bsU;
                    obj.sr = obj.srU;
                    obj.sp = obj.spU;
                case "Gamma1"
                    obj.bs = obj.bsGamma1;
                    obj.sr = obj.srGamma1;
                    obj.sp = obj.spGamma1;
                case "Gamma3"
                    obj.bs = obj.bsGamma3;
                    obj.sr = obj.srGamma3;
                    obj.sp = obj.spGamma3;
                otherwise
                    error("能谷种类判断出错！")
            end
        end
        
    end
    
    methods(Static)
        function [value] = whichValley(es)
            %>计算电子所在能谷标号
            absValley = abs(es.valley);
            if absValley <= 6
                axy = es.vector;
                flagy = axy(2) / abs(axy(2));%可能会有除0错误
                flagz = axy(3) / abs(axy(3));
                alpha = flagy*(acos(axy(1)/sqrt(sum(axy.^2))) - 2*pi * real(sqrt(-flagy)));
                value = flagz*(floor(alpha/(pi/3))+1);
            elseif absValley == 11
                value = 11;
            elseif absValley == 13
                value = 13;
            else
                error("电子所在能谷需先标记！")
            end
        end
        
        function [type] = judgeValleyKind(es)
            %>判断能谷种类
            absValley = abs(es.valley);
            if absValley <= 6
                type = "U";
            elseif absValley == 11
                type = "Gamma1";
            elseif absValley == 13
                type = "Gamma3";
            else
                error("能谷种类判断出错！")
            end
        end
    end
end