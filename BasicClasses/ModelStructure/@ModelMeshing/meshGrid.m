function [grid] = meshGrid(grid, min, max, N, ratio, layerNum)
    %>网格划分
    if ~(isscalar(min) && isscalar(max) && isscalar(N))
        error("输入变量不是标量！")
    end
    grid.face = zeros(N + 1, 1);
    grid.point = zeros(N + 2, 1);
    grid.face(1) = min;
    grid.face(N+1) = max;
    grid.point(1) = min;
    grid.point(N+2) = max;
    if nargin == 4
        delta = (max - min) / N;
        for k = 2 : N + 1
            grid.face(k) = (k - 1) * delta + grid.face(1);
        end
        for k = 2 : N + 1
            grid.point(k) = (grid.face(k) + grid.face(k - 1)) * 0.5;
        end
    elseif nargin == 6
        delta = ratio*(max - min)/((1+ratio)^layerNum ...
                  * (1+ratio*(N - layerNum - 1)) - 1);
        for k = 2 : layerNum + 1
            grid.face(k) = grid.face(k - 1) + delta * (1 + ratio)^(k - 2);
        end
        delta = (max - grid.face(layerNum + 1)) / (N - layerNum);
        for k = layerNum + 2 : N + 1
            grid.face(k) = grid.face(k - 1) + delta;
        end
        for k = 2 : N + 1
            grid.point(k) = (grid.face(k) + grid.face(k - 1)) * 0.5;
        end
    end
end