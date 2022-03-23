classdef PhononQuantityStatics < handle
    
    properties
        NW
        minFrequency
        maxFrequency
        phLAab
        phLAem
        phTAab
        phTAem
        phLOab
        phLOem
        phTOab
        phTOem
        phALLab
        phALLem
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
            obj.phLAab = repmat(FrequncyStatics, NW, 1);
            obj.phLAem = repmat(FrequncyStatics, NW, 1);
            obj.phTAab = repmat(FrequncyStatics, NW, 1);
            obj.phTAem = repmat(FrequncyStatics, NW, 1);
            obj.phLOab = repmat(FrequncyStatics, NW, 1);
            obj.phLOem = repmat(FrequncyStatics, NW, 1);
            obj.phTOab = repmat(FrequncyStatics, NW, 1);
            obj.phTOem = repmat(FrequncyStatics, NW, 1);
            obj.phALLab = repmat(FrequncyStatics, NW, 1);
            obj.phALLem = repmat(FrequncyStatics, NW, 1);
        end
        
        function subPhononQuantityStatics(obj, sh, mm)
            %全部计算一遍
            mm.frequencyGrid(obj.minFrequency, obj.maxFrequency, obj.NW);
            
            sh.pHistory = reshape(sh.pHistory', [], 1);
            obj.frequencys = [sh.pHistory(:).frequency];
            obj.aborems = [sh.pHistory(:).aborem];
            obj.polars = [sh.pHistory(:).polar];
            
            obj.statisticPhonon(mm);
        end
        
        function statisticPhonon(obj, mm)
            % index0用于筛选吸收类型声子
            index0 = obj.aborems == "ab";
            % index1用于筛选发射类型声子
            index1 = obj.aborems == "em";
            for k = 1 : obj.NW
                % index2用于筛选频率范围
                index2 = obj.frequencys > mm.frequency.face(k) & obj.frequencys < mm.frequency.face(k + 1);
                
                % LA统计
                index3 = obj.polars == "LA";
                indexab = index0 & index2 & index3;
                indexem = index1 & index2 & index3;
                % pop中存储单个频率段对应的声子群在sh.pHistory中的标号
                obj.phLAab(k).pop = find(indexab);
                obj.phLAem(k).pop = find(indexem);
                % num中存储单个频率段对应的声子数目
                obj.phLAab(k).num = length(obj.phLAab(k).pop);
                obj.phLAem(k).num = length(obj.phLAem(k).pop);
                
                % TA统计
                index3 = obj.polars == "TA";
                indexab = index0 & index2 & index3;
                indexem = index1 & index2 & index3;
                obj.phTAab(k).pop = find(indexab);
                obj.phTAem(k).pop = find(indexem);
                obj.phTAab(k).num = length(obj.phTAab(k).pop);
                obj.phTAem(k).num = length(obj.phTAem(k).pop);
                
                % LO统计
                index3 = obj.polars == "LO";
                indexab = index0 & index2 & index3;
                indexem = index1 & index2 & index3;
                obj.phLOab(k).pop = find(indexab);
                obj.phLOem(k).pop = find(indexem);
                obj.phLOab(k).num = length(obj.phLOab(k).pop);
                obj.phLOem(k).num = length(obj.phLOem(k).pop);
                
                % TO统计
                index3 = obj.polars == "TO";
                indexab = index0 & index2 & index3;
                indexem = index1 & index2 & index3;
                obj.phTOab(k).pop = find(indexab);
                obj.phTOem(k).pop = find(indexem);
                obj.phTOab(k).num = length(obj.phTOab(k).pop);
                obj.phTOem(k).num = length(obj.phTOem(k).pop);
                
                % 所有极化支
                index3 = obj.polars ~= "non";
                indexab = index0 & index2 & index3;
                indexem = index1 & index2 & index3;
                obj.phALLab(k).pop = find(indexab);
                obj.phALLem(k).pop = find(indexem);
                obj.phALLab(k).num = length(obj.phALLab(k).pop);
                obj.phALLem(k).num = length(obj.phALLem(k).pop);
            end
        end
        
        function [wNumab] = phononSpectrumPlot(obj, mm, pc, type)
            %声子发射谱画图
            wNumab = zeros(obj.NW, 2);
            wNumem = zeros(obj.NW, 2);
            mm.frequencyGrid(obj.minFrequency, obj.maxFrequency, obj.NW);
            switch type
                case "LA"
                    tempab = obj.phLAab;
                    tempem = obj.phLAem;
                case "TA"
                    tempab = obj.phTAab;
                    tempem = obj.phTAem;
                case "LO"
                    tempab = obj.phLOab;
                    tempem = obj.phLOem;
                case "TO"
                    tempab = obj.phTOab;
                    tempem = obj.phTOem;
                case "ALL"
                    tempab = obj.phALLab;
                    tempem = obj.phALLem;
            end
            
            for k = 1 : obj.NW
                wNumab(k, 1) = tempab(k).num;
                wNumab(k, 2) = pc.hbar * mm.frequency.point(k + 1) / pc.e * 1000;
                wNumem(k, 1) = tempem(k).num;
                wNumem(k, 2) = pc.hbar * mm.frequency.point(k + 1) / pc.e * 1000;
            end
            figure
            slg = plot(wNumab(:, 1), wNumab(:, 2));
            slg.LineWidth = 2;
            hold on
            slg = plot(wNumem(:, 1), wNumem(:, 2));
            slg.LineWidth = 2;
            xlabel(".a.u");ylabel("meV");
            legend("phonon absorb numbers", "phonon emission numbers")
        end
        
    end
end