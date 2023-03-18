function [es] = modifyElectricWaveVector(obj, es, pc)
    %>对超出第一布里渊区波矢进行修正
    if obj.electricWhetherBeyondBZ(es.vector, pc)
        es.valley = obj.whichValley(es);
        switch es.valley
            case 1
                es.vector = es.vector - pc.kn.b1;
            case -1
                es.vector = es.vector - pc.kn.b1;
            case 2
                es.vector = es.vector - pc.kn.b2;
            case -2
                es.vector = es.vector - pc.kn.b2;
            case 3
                es.vector = es.vector + pc.kn.b1*rotateMatrix(pi/3, 'z');
            case -3
                es.vector = es.vector + pc.kn.b1*rotateMatrix(pi/3, 'z');
            case 4
                es.vector = es.vector + pc.kn.b1;
            case -4
                es.vector = es.vector + pc.kn.b1;
            case 5
                es.vector = es.vector + pc.kn.b2;
            case -5
                es.vector = es.vector + pc.kn.b2;
            case 6
                es.vector = es.vector - pc.kn.b1*rotateMatrix(pi/3, 'z');
            case -6
                es.vector = es.vector - pc.kn.b1*rotateMatrix(pi/3, 'z');
            case 11
                es.vector = es.vector - es.vector(3)/abs(es.vector(3))*pc.kn.b3;
            case 13
                es.vector = es.vector - es.vector(3)/abs(es.vector(3))*pc.kn.b3;
            otherwise
                error("能谷编号错误！")
        end
    end
    es.valley = obj.whichValley(es);
end