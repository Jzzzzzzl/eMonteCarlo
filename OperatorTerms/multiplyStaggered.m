function multiplyStaggered(mm, result, field1, field2)
    %>交叉网格乘法
    result.datax = field1.datax .* field2.datax;
    result.datay = field1.datay .* field2.datay;
%     for i = 1 : mm.NX + 1
%         for j = 1 : mm.NY + 2
%             result.datax(i, j) = field1.datax(i, j) * field2.datax(i, j);
%         end
%     end
%     for i = 1 : mm.NX + 2
%         for j = 1 : mm.NY + 1
%             result.datay(i, j) = field1.datay(i, j) * field2.datay(i, j);
%         end
%     end
end