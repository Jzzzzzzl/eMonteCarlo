classdef DecideValleyKind < handle
    %% 能谷指向类
    properties
        valley
        valleyU
        valleyG1
        valleyG3
    end
    
    methods
        function obj = DecideValleyKind(pc)
            %>构造函数
            obj.valleyU = ValleyU(pc);
            obj.valleyG1 = ValleyG1(pc);
            obj.valleyG3 = ValleyG3(pc);
        end
        
        function valleyGuidingPrinciple(obj, es)
            %>将dv指向电子所在能谷
            type = obj.judgeValleyKind(es);
            switch type
                case "U"
                    obj.valley = obj.valleyU;
                case "Gamma1"
                    obj.valley = obj.valleyG1;
                case "Gamma3"
                    obj.valley = obj.valleyG3;
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