function [value] = whichValley(es)
    %>计算电子所在能谷标号
    [~, index] = max(abs(es.vector));
    item = es.vector(index) / abs(es.vector(index));
    value = index * item;
end