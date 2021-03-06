function [es] = modifyElectricWaveVector(obj, es, pc)
    %>对超出第一布里渊区波矢进行修正
    if obj.electricWhetherBeyondBZ(es.vector, pc)
        es.valley = obj.whichValley(es);
        switch es.valley
            case 1
                es.vector = es.vector - (pc.kn.b2 + pc.kn.b3);
            case -1
                es.vector = es.vector + (pc.kn.b2 + pc.kn.b3);
            case 2
                es.vector = es.vector - (pc.kn.b1 + pc.kn.b3);
            case -2
                es.vector = es.vector + (pc.kn.b1 + pc.kn.b3);
            case 3
                es.vector = es.vector - (pc.kn.b1 + pc.kn.b2);
            case -3
                es.vector = es.vector + (pc.kn.b1 + pc.kn.b2);
            otherwise
                error("能谷编号错误！")
        end
    end
    es.valley = obj.whichValley(es);
end