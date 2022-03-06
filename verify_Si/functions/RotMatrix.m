function [Rrot] = RotMatrix(theta, type)
    % 在符合右手法则的坐标系中顺时针旋转
    
    switch type
        case 'x'
            Rrot = [1 0 0;0 cos(theta) -sin(theta);0 sin(theta) cos(theta)];
        case 'y'
            Rrot = [cos(theta) 0 sin(theta);0 1 0;-sin(theta) 0 cos(theta)];
        case 'z'
            Rrot = [cos(theta) -sin(theta) 0;sin(theta) cos(theta) 0;0 0 1];
    end

end
