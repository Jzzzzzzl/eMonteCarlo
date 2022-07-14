classdef DecideValleyKind < handle
    %% 能谷指向类
    properties
        valley
        valleyU
        valleyG1
        valleyG3
    end
    
    methods
        function obj = DecideValleyKind(cc, pc, sc)
            %>构造函数
            obj.valleyU = ValleyU(cc, pc, sc);
            obj.valleyG1 = ValleyG1(cc, pc, sc);
            obj.valleyG3 = ValleyG3(cc, pc, sc);
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