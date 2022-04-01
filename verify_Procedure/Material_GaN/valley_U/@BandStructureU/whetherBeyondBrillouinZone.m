function [bool] = whetherBeyondBrillouinZone(~, es, pc)
    %>判断电子波矢是否超出第一布里渊区
    dd = sqrt(sum(es.vector.^2));
    bool = double(dd / pc.dGL) > 1.0;
end