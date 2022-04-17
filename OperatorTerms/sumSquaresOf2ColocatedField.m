function sumSquaresOf2ColocatedField(mm, result, field1, field2)
    %>求两个正交网格平方和
    for i = 1 : mm.NX + 2
        for j = 1 : mm.NY + 2
            result.data(i, j) = sqrt(field1.data(i, j)^2 + field2.data(i, j)^2);
        end
    end
end