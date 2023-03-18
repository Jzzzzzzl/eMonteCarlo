classdef DecideValleyKind < handle
    %% 能谷指向类
    properties
        valley
        valleyGX
    end
    
    methods
        function obj = DecideValleyKind(cc, pc, sc)
            %>构造函数
            obj.valleyGX = ValleyGX(cc, pc, sc);
        end
        
        function valleyGuidingPrinciple(obj, es)
            %>将dv指向电子所在能谷种类
            absValley = abs(es.valley);
            if absValley <= 3
                obj.valley = obj.valleyGX;
            else
                disp(es)
                error("能谷种类判断出错！")
            end
        end
        
    end
end