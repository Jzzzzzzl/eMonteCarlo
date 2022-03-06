function [value] = Random(a, b)
    %随机数
    
    value = a + rand * (b - a);
    
end

