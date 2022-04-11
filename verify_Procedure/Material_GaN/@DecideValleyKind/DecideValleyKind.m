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
            absValley = abs(es.valley);
            if absValley <= 6
                obj.valley = obj.valleyU;
            elseif absValley == 11
                obj.valley = obj.valleyG1;
            elseif absValley == 13
                obj.valley = obj.valleyG3;
            else
                disp(es)
                error("能谷种类判断出错！")
            end
        end
        
    end
end