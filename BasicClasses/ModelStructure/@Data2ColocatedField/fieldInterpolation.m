function fieldInterpolation(obj, field1, field2, method)
    %>场插值
    %不必是均匀网格，但必须正交
    xface = unique(field1(:, 1));
    yface = unique(field1(:, 2));
    disp(['数据文件网格数为：', num2str(length(xface)-1), ' x ', num2str(length(yface)-1)])
    
    for j = 1 : obj.NY
        %y方向互补，x方向相同
        yPoint = obj.modely.face(end) - obj.modely.point(j+1);
        yFace = yface(find(yface > yPoint, 1));
        index = field1(:, 2) == yFace;
        valuex = field1(index, :);
        [~, iv, ~] = unique(valuex(:, 1), 'rows');
        values = valuex(iv, :);
        for i = 1 : obj.NX
            switch method
                case 'spline'
                    field2.data(i+1, j+1) = spline(values(:, 1), values(:, 3), obj.modelx.point(i+1));
                case 'direct'
                    index = find(values(:, 1) >= obj.modelx.point(i+1), 1);
                    if isempty(index)
                        field2.data(i+1, j+1) = values(end, 3);
                    else
                        field2.data(i+1, j+1) = values(index, 3);
                    end
            end
        end
    end
    
end