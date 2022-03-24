function [es] = modifyElectricWaveVector(~, es, pc)
    %>对超出第一布里渊区波矢进行修正
    if whetherBeyondBrillouinZone(es, pc)
        switch es.valley
            case 1
                es.vector(1) = es.vector(1) - 2 * pc.dGX;
            case -1
                es.vector(1) = es.vector(1) + 2 * pc.dGX;
            case 2
                es.vector(2) = es.vector(2) - 2 * pc.dGX;
            case -2
                es.vector(2) = es.vector(2) + 2 * pc.dGX;
            case 3
                es.vector(3) = es.vector(3) - 2 * pc.dGX;
            case -3
                es.vector(3) = es.vector(3) + 2 * pc.dGX;
            otherwise
                error("能谷编号错误！")
        end
        es.valley = DecideValleyKind.whichValley(es);
    end
end