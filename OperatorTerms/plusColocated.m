function plusColocated(mm, result, field1, field2)
    %>正交网格加法
    for i = 1 : mm.NX + 2
        for j = 1 : mm.NY + 2
            result.data(i, j) = field1.data(i, j) + field2.data(i, j);
        end
    end
end