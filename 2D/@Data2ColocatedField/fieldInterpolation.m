function fieldInterpolation(obj, field1, field2)
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
        values = field1(index, :);
        for i = 1 : obj.NX
            field2.data(i+1, j+1) = spline(values(:, 1), values(:, 3), obj.modelx.point(i+1));
        end
    end
    
end