classdef ScatterringProcess < handle
    
    properties
        
    end
    
    methods
        
        function [es] = chooseFinalVectorOfImpurity(obj, es, bs, pc)
            %电离杂质散射电子波矢的选择
            allowedError = 0.1;
            
            agov = es.velocity;
            agovMold = sqrt(sum(agov.^2));
            es.valley = obj.randomValley(es, "i");
            item = 0;
            condition = true;
            while condition && item < 20
                es = bs.chooseWaveVector(es, pc);
                es = bs.computeEnergyAndVelocity(es, pc);
                afterv = es.velocity;
                aftervMold = sqrt(sum(afterv.^2));
                theta = acos(sum(agov .* afterv) / (agovMold * aftervMold));
                situ1 = theta < pi / 2;
                situ2 = abs(agovMold - aftervMold) / agovMold;
                item = item + 1;
                condition = situ1 | situ2 > allowedError;
            end
            
        end
        
        function [es, ps] = chooseFinalVectorOfInterScat(obj, es, ps, bs, sc, pc, type1, type2, type3)
            %谷间散射末态波矢迭代选择,根据能量守恒
            item = 1;
            error = 1;
            maxitem = 20;
            allowedError = 0.1;
            % 谷间散射种类判断
            switch type1
                case "f"
                    qq = pc.qf;
                case "g"
                    qq = pc.qg;
            end
            % 吸收发射种类判断
            switch type2
                case "ab"
                    flag = 1;
                case "em"
                    flag = -1;
            end
            % 极化支种类判断
            switch type3
                case "LA"
                    omegaCurve = sc.omegaLA;
                case "TA"
                    omegaCurve = sc.omegaTA;
                case "LO"
                    omegaCurve = sc.omegaLO;
                case "TO"
                    omegaCurve = sc.omegaTO;
            end
            
            ps.position = es.position;
            ps.time = es.time;
            ps.aborem = type2;
            ps.polar = type3;
            
            agoVector = es.vector;
            frequency = double(omegaCurve(qq));
            phononEnergy = double(pc.hbar * frequency);
            es.energy = es.energy + flag * phononEnergy;
            es.valley = obj.randomValley(es, type1);
            while item < maxitem && error > allowedError
                es = bs.chooseWaveVector(es, pc);
                ps.vector = es.vector - agoVector;
                ps = bs.phononWhetherBeyondBZone(ps, pc);
                ps.getFrequency(sc);
                error = abs((ps.energy - phononEnergy) / ps.energy);
                item = item + 1;
            end
            
        end
        
        function [es,ps] = electricScatProcess(obj, es, ps, bs, sc, pc, sr)
            %针对不同散射类型计算电子声子散射过程
            switch sr.scatType
                case 1 % e-impurity
                    es = obj.chooseFinalVectorOfImpurity(es, bs, pc);
                case 2 % intra_LA
                    es = bs.chooseWaveVector(es, pc);
                case 3 % intra_TA
                    es = bs.chooseWaveVector(es, pc);
                case 4 % inter_g_ab_TA
                    [es, ps] = obj.chooseFinalVectorOfInterScat(es, ps, bs, sc, pc, "g", "ab", "TA");
                case 5 % inter_g_ab_LA
                    [es, ps] = obj.chooseFinalVectorOfInterScat(es, ps, bs, sc, pc, "g", "ab", "LA");
                case 6 % inter_g_ab_LO
                    [es, ps] = obj.chooseFinalVectorOfInterScat(es, ps, bs, sc, pc, "g", "ab", "LO");
                case 7 % inter_f_ab_TA
                    [es, ps] = obj.chooseFinalVectorOfInterScat(es, ps, bs, sc, pc, "f", "ab", "TA");
                case 8 % inter_f_ab_LA
                    [es, ps] = obj.chooseFinalVectorOfInterScat(es, ps, bs, sc, pc, "f", "ab", "LA");
                case 9 % inter_f_ab_TO
                    [es, ps] = obj.chooseFinalVectorOfInterScat(es, ps, bs, sc, pc, "f", "ab", "TO");
                case 10 % inter_g_em_TA
                    [es, ps] = obj.chooseFinalVectorOfInterScat(es, ps, bs, sc, pc, "g", "em", "TA");
                case 11 % inter_g_em_LA
                    [es, ps] = obj.chooseFinalVectorOfInterScat(es, ps, bs, sc, pc, "g", "em", "LA");
                case 12 % inter_g_em_LO
                    [es, ps] = obj.chooseFinalVectorOfInterScat(es, ps, bs, sc, pc, "g", "em", "LO");
                case 13 % inter_f_em_TA
                    [es, ps] = obj.chooseFinalVectorOfInterScat(es, ps, bs, sc, pc, "f", "em", "TA");
                case 14 % inter_f_em_LA
                    [es, ps] = obj.chooseFinalVectorOfInterScat(es, ps, bs, sc, pc, "f", "em", "LA");
                case 15 % inter_f_em_TO
                    [es, ps] = obj.chooseFinalVectorOfInterScat(es, ps, bs, sc, pc, "f", "em", "TO");
                case 16 % 
                    return;
            end
        end
        
    end
    
    methods(Static)
        
        function value = randomValley(es, type)
            %随机选择能谷
            switch type
                case "i"
                    valleys = [1, -1, 2, -2, 3, -3];
                    index = round(randnumber(0.5, 6.5));
                    value = valleys(index);
                case "f"
                    valley0 = abs(es.valley);
                    valleys1 = [2, -2, 3, -3];
                    valleys2 = [1, -1, 3, -3];
                    valleys3 = [1, -1, 2, -2];
                    index = round(randnumber(0.5, 4.5));
                    switch valley0
                        case 1
                            value = valleys1(index);
                        case 2
                            value = valleys2(index);
                        case 3
                            value = valleys3(index);
                    end
                case "g"
                    value = -1*es.valley;
            end
            
        end
        
    end
end
