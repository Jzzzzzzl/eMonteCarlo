function [vector2] = rotateToStandardValley(~, vector1, valley)
    %>从其他能谷转向标准能谷
    switch valley
        case 13
            vector2 = vector1;
        otherwise
            disp(valley)
            error("能谷标号错误！")
    end
end