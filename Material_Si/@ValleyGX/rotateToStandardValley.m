function [vector2] = rotateToStandardValley(vector1, valley)
    %>从其他能谷转向标准能谷
    switch valley
        case 1
            vector2 = vector1*rotateMatrix(pi/2, 'y');
        case -1
            vector2 = vector1*rotateMatrix(-pi/2, 'y');
        case 2
            vector2 = vector1*rotateMatrix(-pi/2, 'x');
        case -2
            vector2 = vector1*rotateMatrix(pi/2, 'x');
        case 3
            vector2 = vector1*rotateMatrix(0, 'x');
        case -3
            vector2 = vector1*rotateMatrix(pi, 'x');
        otherwise
            disp(valley)
            error("能谷标号错误！")
    end
end