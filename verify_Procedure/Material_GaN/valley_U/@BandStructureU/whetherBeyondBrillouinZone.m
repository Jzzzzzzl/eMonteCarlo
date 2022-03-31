function [bool] = whetherBeyondBrillouinZone(~, es, pc)
    %>判断电子波矢是否超出第一布里渊区
    dd = sqrt(es.vector(1).^2 + es.vector(2).^2);
    bool = double(dd / pc.dGM) > 1.0;
end