classdef ScatterringProcessU < ScatterringProcessForValley
    %% U能谷散射过程
    methods
        function [es, ps] = electricScatProcess(obj, es, ps, dv, sc, pc)
            %>针对不同散射类型计算电子声子散射过程
            ps.time = es.time;
            ps.position = es.position;
            switch dv.sr.scatType
                case 1 % ionized impurity
                    es = obj.chooseFinalVectorForIonizedImpurityScattering(es, dv, pc);
                case 2 % acoustic piezoelectric
                    es = obj.chooseFinalVectorForAcousticPiezoelectricScattering(es, dv, pc);
                case 3 % intra
                    es = dv.bs.chooseElectricWaveVector(es, pc, randNumber(0, pi));
                case 4 % polar LO ab
                    ps.aborem = "ab";
                    ps.polar = "LO";
                    [es, ps] = obj.chooseFinalVectorForPolarOpticalScattering(es, ps, dv, sc, pc, sc.wPolarLO, 1);
                case 5 % polar LO em
                    ps.aborem = "em";
                    ps.polar = "LO";
                    [es, ps] = obj.chooseFinalVectorForPolarOpticalScattering(es, ps, dv, sc, pc, sc.wPolarLO, -1);
                case 6 % inter UU LA ab
                    ps.aborem = "ab";
                    ps.polar = "LA";
                    es.valley = obj.randomValley(es, "interUU");
                    dv.valleyGuidingPrinciple(es);
                    [es, ps] = obj.chooseFinalVectorForIntervalleyScattering(es, ps, dv, sc, pc, sc.wU2ULA, 1);
                case 7 % inter UU LO ab
                    ps.aborem = "ab";
                    ps.polar = "LO";
                    es.valley = obj.randomValley(es, "interUU");
                    dv.valleyGuidingPrinciple(es);
                    [es, ps] = obj.chooseFinalVectorForIntervalleyScattering(es, ps, dv, sc, pc, sc.wU2ULO, 1);
                case 8 % inter UU LA em
                    ps.aborem = "em";
                    ps.polar = "LA";
                    es.valley = obj.randomValley(es, "interUU");
                    dv.valleyGuidingPrinciple(es);
                    [es, ps] = obj.chooseFinalVectorForIntervalleyScattering(es, ps, dv, sc, pc, sc.wU2ULA, -1);
                case 9 % inter UU LO em
                    ps.aborem = "em";
                    ps.polar = "LO";
                    es.valley = obj.randomValley(es, "interUU");
                    dv.valleyGuidingPrinciple(es);
                    [es, ps] = obj.chooseFinalVectorForIntervalleyScattering(es, ps, dv, sc, pc, sc.wU2ULO, -1);
                case 10 % inter UG1 LA ab
                    ps.aborem = "ab";
                    ps.polar = "LA";
                    es.valley = obj.randomValley(es, "interUG1");
                    dv.valleyGuidingPrinciple(es);
                    [es, ps] = obj.chooseFinalVectorForIntervalleyScattering(es, ps, dv, sc, pc, sc.wU2GLA, 1);
                case 11 % inter UG1 LO ab
                    ps.aborem = "ab";
                    ps.polar = "LO";
                    es.valley = obj.randomValley(es, "interUG1");
                    dv.valleyGuidingPrinciple(es);
                    [es, ps] = obj.chooseFinalVectorForIntervalleyScattering(es, ps, dv, sc, pc, sc.wU2GLO, 1);
                case 12 % inter UG1 LA em
                    ps.aborem = "em";
                    ps.polar = "LA";
                    es.valley = obj.randomValley(es, "interUG1");
                    dv.valleyGuidingPrinciple(es);
                    [es, ps] = obj.chooseFinalVectorForIntervalleyScattering(es, ps, dv, sc, pc, sc.wU2GLA, -1);
                case 13 % inter UG1 LO em
                    ps.aborem = "em";
                    ps.polar = "LO";
                    es.valley = obj.randomValley(es, "interUG1");
                    dv.valleyGuidingPrinciple(es);
                    [es, ps] = obj.chooseFinalVectorForIntervalleyScattering(es, ps, dv, sc, pc, sc.wU2GLO, -1);
                case 14 % inter UG3 LA ab
                    ps.aborem = "ab";
                    ps.polar = "LA";
                    es.valley = obj.randomValley(es, "interUG3");
                    dv.valleyGuidingPrinciple(es);
                    [es, ps] = obj.chooseFinalVectorForIntervalleyScattering(es, ps, dv, sc, pc, sc.wU2GLA, 1);
                case 15 % inter UG3 LO ab
                    ps.aborem = "ab";
                    ps.polar = "LO";
                    es.valley = obj.randomValley(es, "interUG3");
                    dv.valleyGuidingPrinciple(es);
                    [es, ps] = obj.chooseFinalVectorForIntervalleyScattering(es, ps, dv, sc, pc, sc.wU2GLO, 1);
                case 16 % inter UG3 LA em
                    ps.aborem = "em";
                    ps.polar = "LA";
                    es.valley = obj.randomValley(es, "interUG3");
                    dv.valleyGuidingPrinciple(es);
                    [es, ps] = obj.chooseFinalVectorForIntervalleyScattering(es, ps, dv, sc, pc, sc.wU2GLA, -1);
                case 17 % inter UG3 LO em
                    ps.aborem = "em";
                    ps.polar = "LO";
                    es.valley = obj.randomValley(es, "interUG3");
                    dv.valleyGuidingPrinciple(es);
                    [es, ps] = obj.chooseFinalVectorForIntervalleyScattering(es, ps, dv, sc, pc, sc.wU2GLO, -1);
                case 18 % 
                    return;
            end
        end
        
    end
    
    methods(Static)
        function value = randomValley(es, type)
            %>随机选择能谷
            switch type
                case "interUU"
                    valleys = [1, -1, 2, -2, 3, -3, 4, -4, 5, -5, 6, -6];
                    index = round(randNumber(0.5, 12.5));
                    value = valleys(index);
                case "interUG1"
                    value = 11;
                case "interUG3"
                    value = 13;
            end
        end
        
    end
end
