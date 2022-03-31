function [bool] = whetherBeyondBrillouinZone(~, es, pc)
    %>判断电子波矢是否超出第一布里渊区
    bool = double(max(abs(es.vector)) / pc.dGX) > 1.0;
end