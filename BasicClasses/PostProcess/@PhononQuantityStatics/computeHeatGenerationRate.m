function computeHeatGenerationRate(obj, pc, cc, sc)
    %>计算热产生率
    % 循环所有频率段，尤其注意不同极化支的频率范围
    for k = 1 : cc.NW
        deltaw = cc.frequency.face(k+1) - cc.frequency.face(k);
        pLAab = sh.eHistory(obj.phLAab(k).pop);
        pLAem = sh.eHistory(obj.phLAem(k).pop);
        pTAab = sh.eHistory(obj.phTAab(k).pop);
        pTAem = sh.eHistory(obj.phTAem(k).pop);
        pLOab = sh.eHistory(obj.phLOab(k).pop);
        pLOem = sh.eHistory(obj.phLOem(k).pop);
        pTOab = sh.eHistory(obj.phTOab(k).pop);
        pTOem = sh.eHistory(obj.phTOem(k).pop);
        % 扫描模型内部区域
        for i = 1 : cc.NX
            for j = 1 : cc.NY
                energyLAem = 0; energyLAab = 0;
                energyTAem = 0; energyTAab = 0;
                energyLOem = 0; energyLOab = 0;
                energyTOem = 0; energyTOab = 0;
                
                if ~isempty(pLAab); energyLAab = computeSumEnergy(pLAab, cc, i, j); end
                if ~isempty(pLAem); energyLAem = computeSumEnergy(pLAem, cc, i, j); end
                if ~isempty(pTAab); energyTAab = computeSumEnergy(pTAab, cc, i, j); end
                if ~isempty(pTAem); energyTAem = computeSumEnergy(pTAem, cc, i, j); end
                if ~isempty(pLOab); energyLOab = computeSumEnergy(pLOab, cc, i, j); end
                if ~isempty(pLOem); energyLOem = computeSumEnergy(pLOem, cc, i, j); end
                if ~isempty(pTOab); energyTOab = computeSumEnergy(pTOab, cc, i, j); end
                if ~isempty(pTOem); energyTOem = computeSumEnergy(pTOem, cc, i, j); end
                % 只能在极化支的频率定义域内进行计算
                if sc.dosLA(k+1) ~= 0
                    obj.Q(k).LA.data(i+1, j+1) = cc.eleConc.data(i+1, j+1) * (energyLAem - energyLAab) / (cc.superElecs*obj.minimumTime);
                    obj.nDot(k).LA.data(i+1, j+1) = obj.Q(k).LA.data(i+1, j+1) / (pc.hbar*cc.frequency.point(k+1)*sc.dosLA(k+1)*deltaw)*cc.xsfornDot;
                end
                if sc.dosTA(k+1) ~= 0
                    obj.Q(k).TA.data(i+1, j+1) = cc.eleConc.data(i+1, j+1) * (energyTAem - energyTAab) / (cc.superElecs*obj.minimumTime);
                    obj.nDot(k).TA.data(i+1, j+1) = obj.Q(k).TA.data(i+1, j+1) / (pc.hbar*cc.frequency.point(k+1)*sc.dosTA(k+1)*deltaw)*cc.xsfornDot;
                end
                if sc.dosLO(k+1) ~= 0
                    obj.Q(k).LO.data(i+1, j+1) = cc.eleConc.data(i+1, j+1) * (energyLOem - energyLOab) / (cc.superElecs*obj.minimumTime);
                    obj.nDot(k).LO.data(i+1, j+1) = obj.Q(k).LO.data(i+1, j+1) / (pc.hbar*cc.frequency.point(k+1)*sc.dosLO(k+1)*deltaw)*cc.xsfornDot;
                end
                if sc.dosTO(k+1) ~= 0
                    obj.Q(k).TO.data(i+1, j+1) = cc.eleConc.data(i+1, j+1) * (energyTOem - energyTOab) / (cc.superElecs*obj.minimumTime);
                    obj.nDot(k).TO.data(i+1, j+1) = obj.Q(k).TO.data(i+1, j+1) / (pc.hbar*cc.frequency.point(k+1)*sc.dosTO(k+1)*deltaw)*cc.xsfornDot;
                end
            end
        end
    end
    
    function [value] = computeSumEnergy(phonons, cc, i, j)
        %>
        r = [phonons(:).position];
        rx = double(r(1 : 3 : end-2)');
        ry = double(r(2 : 3 : end-1)');
        index1 = rx > cc.modelx.face(i) & rx < cc.modelx.face(i+1);
        index2 = ry > cc.modely.face(j) & ry < cc.modely.face(j+1);
        phonon = phonons(index1 & index2);
        value = sum([phonon(:).energy]);
    end
    
end
