classdef PhononQuantityStatics < handle
    
    properties
        NW
        minFrequency
        maxFrequency
        phLAs
        phTAs
        phLOs
        phTOs
        phALL
        frequencys
        aborems
        polars
    end
    
    methods
        
        function obj = PhononQuantityStatics(pc, NW)
            %构造函数
            obj.NW = NW;
            obj.minFrequency = 0;
            obj.maxFrequency = pc.maxFrequency;
            FrequncyStatics = struct("pop", {0}, "num", {0});
            obj.phLAs = repmat(FrequncyStatics, NW, 1);
            obj.phTAs = repmat(FrequncyStatics, NW, 1);
            obj.phLOs = repmat(FrequncyStatics, NW, 1);
            obj.phTOs = repmat(FrequncyStatics, NW, 1);
            obj.phALL = repmat(FrequncyStatics, NW, 1);
        end
        
        function subPhononQuantityStatics(obj, sh, mm)
            %全部计算一遍
            mm.frequencyGrid(obj.minFrequency, obj.maxFrequency, obj.NW);
            
            sh.pHistory = reshape(sh.pHistory', [], 1);
            obj.frequencys = [sh.pHistory(:).frequency];
            obj.aborems = [sh.pHistory(:).aborem];
            obj.polars = [sh.pHistory(:).polar];
            
            obj.statisticPhonon(mm, "LA");
            obj.statisticPhonon(mm, "TA");
            obj.statisticPhonon(mm, "LO");
            obj.statisticPhonon(mm, "TO");
            obj.statisticPhonon(mm, "ALL");
        end
        
        function statisticPhonon(obj, mm, type)
            % index1用于筛选发射类型声子
            index1 = obj.aborems == "em";
            switch type
                case "LA"
                    % index2用于筛选极化支
                    index2 = obj.polars == "LA";
                    for k = 1 : obj.NW
                        % index3用于筛选频率范围
                        index3 = obj.frequencys > mm.frequency.face(k) & obj.frequencys < mm.frequency.face(k + 1);
                        index = index1 & index2 & index3;
                        % pop中存储单个频率段对应的声子群在sh.pHistory中的标号
                        obj.phLAs(k).pop = find(index);
                        % num中存储单个频率段对应的声子数目
                        obj.phLAs(k).num = length(obj.phLAs(k).pop);
                    end
                case "TA"
                    index2 = obj.polars == "TA";
                    for k = 1 : obj.NW
                        index3 = obj.frequencys > mm.frequency.face(k) & obj.frequencys < mm.frequency.face(k + 1);
                        index = index1 & index2 & index3;
                        obj.phTAs(k).pop = find(index);
                        obj.phTAs(k).num = length(obj.phTAs(k).pop);
                    end
                case "LO"
                    index2 = obj.polars == "LO";
                    for k = 1 : obj.NW
                        index3 = obj.frequencys > mm.frequency.face(k) & obj.frequencys < mm.frequency.face(k + 1);
                        index = index1 & index2 & index3;
                        obj.phLOs(k).pop = find(index);
                        obj.phLOs(k).num = length(obj.phLOs(k).pop);
                    end
                case "TO"
                    index2 = obj.polars == "TO";
                    for k = 1 : obj.NW
                        index3 = obj.frequencys > mm.frequency.face(k) & obj.frequencys < mm.frequency.face(k + 1);
                        index = index1 & index2 & index3;
                        obj.phTOs(k).pop = find(index);
                        obj.phTOs(k).num = length(obj.phTOs(k).pop);
                    end
                case "ALL"
                    index2 = obj.polars ~= "non";
                    for k = 1 : obj.NW
                        index3 = obj.frequencys > mm.frequency.face(k) & obj.frequencys < mm.frequency.face(k + 1);
                        index = index1 & index2 & index3;
                        obj.phALL(k).pop = find(index);
                        obj.phALL(k).num = length(obj.phALL(k).pop);
                    end
            end
        end
        
        function [wNum] = phononEmSpectrumPlot(obj, mm, pc, type)
            %声子发射谱画图
            wNum = zeros(obj.NW, 2);
            mm.frequencyGrid(obj.minFrequency, obj.maxFrequency, obj.NW);
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