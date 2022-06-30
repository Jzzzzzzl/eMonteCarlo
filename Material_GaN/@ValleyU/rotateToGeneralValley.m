function [vector2] = rotateToGeneralValley(~, vector1, valley)
    %>从标准能谷转向其他能谷
    switch valley
        case 1
            vector2 = vector1*rotateMatrix(-1.2305, 'y')*rotateMatrix(-pi/6, 'z');
        case -1
            vector2 = vector1*rotateMatrix(-(pi-1.2305), 'y')*rotateMatrix(-pi/6, 'z');
        case 2
            vector2 = vector1*rotateMatrix(1.2305, 'x');
        case -2
            vector2 = vector1*rotateMatrix(pi-1.2305, 'x');
        case 3
            vector2 = vector1*rotateMatrix(-1.2305, 'y')*rotateMatrix(-5*pi/6, 'z');
        case -3
            vector2 = vector1*rotateMatrix(-(pi-1.2305), 'y')*rotateMatrix(-5*pi/6, 'z');
        case 4
            vector2 = vector1*rotateMatrix(-1.2305,'y')*rotateMatrix(5*pi/6, 'z');
        case -4
            vector2 = vector1*rotateMatrix(-(pi-1.2305), 'y')*rotateMatrix(5*pi/6, 'z');
        case 5
            vector2 = vector1*rotateMatrix(-1.2305, 'x');
        case -5
            vector2 = vector1*rotateMatrix(-(pi-1.2305), 'x');
        case 6
            vector2 = vector1*rotateMatrix(-1.2305, 'y')*rotateMatrix(pi/6, 'z');
        case -6
            vector2 = vector1*rotateMatrix(-(pi-1.2305), 'y')*rotateMatrix(pi/6, 'z');
        otherwise
            disp(valley)
            error("能谷标号错误！")
    end
end