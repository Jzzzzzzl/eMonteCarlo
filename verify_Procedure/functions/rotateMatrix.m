function [rMatrix] = rotateMatrix(theta, type)
    % 在符合右手法则的坐标系中顺时针旋转
    switch type
        case "x"
            rMatrix = [1 0 0;0 cos(theta) -sin(theta);0 sin(theta) cos(theta)];
        case "y"
            rMatrix = [cos(theta) 0 sin(theta);0 1 0;-sin(theta) 0 cos(theta)];
        case "z"
            rMatrix = [cos(theta) -sin(theta) 0;sin(theta) cos(theta) 0;0 0 1];
    end
end
