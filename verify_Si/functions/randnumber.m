function [value] = randnumber(a, b)
    %随机数
    
    value = a + rand * (b - a);
    
end

