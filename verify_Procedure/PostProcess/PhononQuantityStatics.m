classdef PhononQuantityStatics < handle
    
    properties
        NW
        phLAs
        phTAs
        phLOs
        phTOs
        phALL
        phonons
    end
    
    methods
        
        function obj = PhononQuantityStatics(NW)
            %构造函数
            obj.NW = NW;
            FrequncyStatics = struct("pop", {0}, "num", {0});
            obj.phLAs = repmat(FrequncyStatics, NW, 1);
            obj.phTAs = repmat(FrequncyStatics, NW, 1);
            obj.phLOs = repmat(FrequncyStatics, NW, 1);
            obj.phTOs = repmat(FrequncyStatics, NW, 1);
            obj.phALL = repmat(FrequncyStatics, NW, 1);
            
        end
        
        function subPhononQuantityStatics(obj, sh, mm, sc, cc)
            %全部计算一遍
            mm.frequencyGrid(sc.wMinLA, sc.wMaxTO, obj.NW);
            obj.statisticPhonon(sh, mm, cc, "LA");
            obj.statisticPhonon(sh, mm, cc, "TA");
            obj.statisticPhonon(sh, mm, cc, "LO");
            obj.statisticPhonon(sh, mm, cc, "TO");
            obj.statisticPhonon(sh, mm, cc, "ALL");
            
        end
        
        function statisticPhonon(obj, sh, mm, cc, type)
            %统计各个频率段的声子群
            obj.phonons = reshape(sh.pHistory', [], 1);
            frequencys = zeros(cc.superElecs * cc.noFly, 1);
            aborems = string(zeros(cc.superElecs * cc.noFly, 1));
            polars = string(zeros(cc.superElecs * cc.noFly, 1));
            for i = 1 : cc.superElecs * cc.noFly
                frequencys(i) = obj.phonons(i).frequency;
                aborems(i) = obj.phonons(i).aborem;
                polars(i) = obj.phonons(i).polar;
            end
            
            % index1用于筛选发射声子
            index1 = aborems == "em";
            
            switch type
                case "LA"
                    index2 = polars == "LA";
                    for k = 1 : obj.NW
                        index3 = frequencys > mm.frequency.face(k) & frequencys < mm.frequency.face(k + 1);
                        index = index1 & index2 & index3;
                        % pop中存储单个频率段对应的声子群在phonons中的标号
                        obj.phLAs(k).pop = find(index);
                        % num中存储单个频率段对应的声子数目
                        obj.phLAs(k).num = length(obj.phLAs(k).pop);
                    end
                case "TA"
                    index2 = polars == "TA";
                    for k = 1 : obj.NW
                        index3 = frequencys > mm.frequency.face(k) & frequencys < mm.frequency.face(k + 1);
                        index = index1 & index2 & index3;
                        obj.phTAs(k).pop = find(index);
                        obj.phTAs(k).num = length(obj.phTAs(k).pop);
                    end
                case "LO"
                    index2 = polars == "LO";
                    for k = 1 : obj.NW
                        index3 = frequencys > mm.frequency.face(k) & frequencys < mm.frequency.face(k + 1);
                        index = index1 & index2 & index3;
                        obj.phLOs(k).pop = find(index);
                        obj.phLOs(k).num = length(obj.phLOs(k).pop);
                    end
                case "TO"
                    index2 = polars == "TO";
                    for k = 1 : obj.NW
                        index3 = frequencys > mm.frequency.face(k) & frequencys < mm.frequency.face(k + 1);
                        index = index1 & index2 & index3;
                        obj.phTOs(k).pop = find(index);
                        obj.phTOs(k).num = length(obj.phTOs(k).pop);
                    end
                case "ALL"
                    index2 = polars ~= "non";
                    for k = 1 : obj.NW
                        index3 = frequencys > mm.frequency.face(k) & frequencys < mm.frequency.face(k + 1);
                        index = index1 & index2 & index3;
                        obj.phALL(k).pop = find(index);
                        obj.phALL(k).num = length(obj.phALL(k).pop);
                    end
            end
            
        end
        
        function phononEmSpectrum(obj, mm, sc, pc, type)
            %求声子发射谱
            wNum = zeros(obj.NW, 2);
            mm.frequencyGrid(sc.wMinLA, sc.wMaxTO, obj.NW);
            switch type
                case "LA"
                    temp = obj.phLAs;
                case "TA"
                    temp = obj.phTAs;
                case "LO"
                    temp = obj.phLOs;
                case "TO"
                    temp = obj.phTOs;
                case "ALL"
                    temp = obj.phALL;
            end
            
            for k = 1 : obj.NW
                wNum(k, 1) = temp(k).num;
                wNum(k, 2) = pc.hbar * mm.frequency.point(k + 1) / pc.e * 1000;
            end
            figure
            slg = plot(wNum(:, 1), wNum(:, 2));
            slg.LineWidth = 2;
            xlabel(".a.u");ylabel("meV");
            legend(" phonon emission numbers")
            
        end
        
    end
end