function [vector2] = rotateToStandardValley(~, vector1, valley)
    %>从其他能谷转向标准能谷
    switch valley
        case 1
            vector2 = vector1*rotateMatrix(pi/6, "z")*rotateMatrix(1.2305, "y");
        case -1
            vector2 = vector1*rotateMatrix(pi/6, "z")*rotateMatrix(pi-1.2305, "y");
        case 2
            vector2 = vector1*rotateMatrix(-1.2305, "x");
        case -2
            vector2 = vector1*rotateMatrix(-(pi-1.2305), "x");
        case 3
            vector2 = vector1*rotateMatrix(5*pi/6, "z")*rotateMatrix(1.2305, "y");
        case -3
            vector2 = vector1*rotateMatrix(5*pi/6, "z")*rotateMatrix(pi-1.2305, "y");
        case 4
            vector2 = vector1*rotateMatrix(-5*pi/6, "z")*rotateMatrix(1.2305, "y");
        case -4
            vector2 = vector1*rotateMatrix(-5*pi/6, "z")*rotateMatrix(pi-1.2305, "y");
        case 5
            vector2 = vector1*rotateMatrix(1.2305, "x");
        case -5
            vector2 = vector1*rotateMatrix(pi-1.2305, "x");
        case 6
            vector2 = vector1*rotateMatrix(-pi/6, "z")*rotateMatrix(1.2305, "y");
        case -6
            vector2 = vector1*rotateMatrix(-pi/6, "z")*rotateMatrix(pi-1.2305, "y");
        otherwise
            disp(valley)
            error("能谷标号错误！")
    end
end