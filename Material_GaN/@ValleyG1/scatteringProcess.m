function [es,ps] = scatteringProcess(obj, dv, es, ps, sc, pc)
    %>针对不同散射类型计算电子声子散射过程
    ps.time = es.time;
    vectorTemp = es.vector;
    ps.position = es.position;
    switch es.scatype
        case 1 % ionized impurity
            ps.polar = -1;
            k = obj.chooseStandardVectorForScattering(es, pc);
            es = obj.getGeneralElectricWaveVector(es, pc, k);
        case 2 % acoustic piezoelectric
            ps.polar = -1;
            k = obj.chooseStandardVectorForScattering(es, pc);
            es = obj.getGeneralElectricWaveVector(es, pc, k);
        case 3 % intra
            ps.polar = -1;
            k = obj.chooseStandardVectorForScattering(es, pc);
            es = obj.getGeneralElectricWaveVector(es, pc, k);
        case 4 % polar LO ab
            ps.aborem = 0;
            ps.polar = 3;
            k = obj.chooseStandardVectorForScattering(es, pc, sc.wPolarLO, 1);
            es = obj.getGeneralElectricWaveVector(es, pc, k);
        case 5 % polar LO em
            ps.aborem = 1;
            ps.polar = 3;
            k = obj.chooseStandardVectorForScattering(es, pc, sc.wPolarLO, -1);
            es = obj.getGeneralElectricWaveVector(es, pc, k);
        case 6 % inter G1U LO ab
            ps.aborem = 0;
            ps.polar = 3;
            es.valley = randomValley(es, 'u');
            dv.valleyGuidingPrinciple(es);
            k = dv.valley.chooseStandardVectorForScattering(es, pc, sc.wU2GLO, 1);
            es = dv.valley.getGeneralElectricWaveVector(es, pc, k);
        case 7 % inter G1U LO em
            ps.aborem = 1;
            ps.polar = 3;
            es.valley = randomValley(es, 'u');
            dv.valleyGuidingPrinciple(es);
            k = dv.valley.chooseStandardVectorForScattering(es, pc, sc.wU2GLO, -1);
            es = dv.valley.getGeneralElectricWaveVector(es, pc, k);
        case 8 % inter G1G3 LO ab
            ps.aborem = 0;
            ps.polar = 3;
            es.valley = randomValley(es, 't');
            dv.valleyGuidingPrinciple(es);
            k = dv.valley.chooseStandardVectorForScattering(es, pc, sc.wG2GLO, 1);
            es = dv.valley.getGeneralElectricWaveVector(es, pc, k);
        case 9 % inter G1G3 LO em
            ps.aborem = 1;
            ps.polar = 3;
            es.valley = randomValley(es, 't');
            dv.valleyGuidingPrinciple(es);
            k = dv.valley.chooseStandardVectorForScattering(es, pc, sc.wG2GLO, -1);
            es = dv.valley.getGeneralElectricWaveVector(es, pc, k);
        case 10 % 
            ps.polar = -1;
            return;
    end
    
    if ps.polar ~= -1
        ps.vector = es.vector - vectorTemp;
        ps = dv.valley.phononWhetherBeyondBZ(ps, pc);
        ps.getFrequency(sc);
    end
    
    function value = randomValley(~, type)
        %>随机选择能谷
        switch type
            case 'u'
                valleys = [1, -1, 2, -2, 3, -3, ...
                              4, -4, 5, -5, 6, -6];
                index = round(randNumber(0.5, length(valleys)+0.5));
                value = valleys(index);
            case 't'
                value = 13;
        end
    end
end