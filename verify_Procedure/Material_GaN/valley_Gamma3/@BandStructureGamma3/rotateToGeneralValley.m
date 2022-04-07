function [vector2] = rotateToGeneralValley(~, vector1, valley)
    %>从标准能谷转向其他能谷
    switch valley
        case 13
            vector2 = vector1;
        otherwise
            disp(valley)
            error("能谷标号错误！")
    end
end