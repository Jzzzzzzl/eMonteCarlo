function heatGenerationRate(obj, sh, pc, cc, sc)
    %>计算热产生率
    % 循环所有频率段，尤其注意不同极化支的频率范围
    for k = 1 : cc.NW
        deltaw = cc.frequency.face(k+1) - cc.frequency.face(k);
        pLAab = sh.eHistory(phLAab(k).pop);
        pLAem = sh.eHistory(phLAem(k).pop);
        pTAab = sh.eHistory(phTAab(k).pop);
        pTAem = sh.eHistory(phTAem(k).pop);
        pLOab = sh.eHistory(phLOab(k).pop);
        pLOem = sh.eHistory(phLOem(k).pop);
        pTOab = sh.eHistory(phTOab(k).pop);
        pTOem = sh.eHistory(phTOem(k).pop);
        % 扫描模型内部区域
        for i = 1 : cc.NX
            for j = 1 : cc.NY
                energyLAem = 0; energyLAab = 0;
                energyTAem = 0; energyTAab = 0;
                energyLOem = 0; energyLOab = 0;
                energyTOem = 0; energyTOab = 0;
                
                if ~isempty(pLAab)
                    r = [pLAab(:).position];
                    x = double(r(1 : 3 : end-2)');
                    y = double(r(2 : 3 : end-1)');
                    index1 = x > cc.modelx.face(i) & x < cc.modelx.face(i+1);
                    index2 = y > cc.modely.face(j) & y < cc.modely.face(j+1);
                    interPhonon = pLAab(index1 & index2);
                    energyLAab = sum([interPhonon(:).energy]);
                end
                if ~isempty(pLAem)
                    r = [pLAem(:).position];
                    x = double(r(1 : 3 : end-2)');
                    y = double(r(2 : 3 : end-1)');
                    index1 = x > cc.modelx.face(i) & x < cc.modelx.face(i+1);
                    index2 = y > cc.modely.face(j) & y < cc.modely.face(j+1);
                    interPhonon = pLAem(index1 & index2);
                    energyLAem = sum([interPhonon(:).energy]);
                end
                if ~isempty(pTAab)
                    r = [pTAab(:).position];
                    x = double(r(1 : 3 : end-2)');
                    y = double(r(2 : 3 : end-1)');
                    index1 = x > cc.modelx.face(i) & x < cc.modelx.face(i+1);
                    index2 = y > cc.modely.face(j) & y < cc.modely.face(j+1);
                    interPhonon = pTAab(index1 & index2);
                    energyTAab = sum([interPhonon(:).energy]);
                end
                if ~isempty(pTAem)
                    r = [pTAem(:).position];
                    x = double(r(1 : 3 : end-2)');
                    y = double(r(2 : 3 : end-1)');
                    index1 = x > cc.modelx.face(i) & x < cc.modelx.face(i+1);
                    index2 = y > cc.modely.face(j) & y < cc.modely.face(j+1);
                    interPhonon = pTAem(index1 & index2);
                    energyTAem = sum([interPhonon(:).energy]);
                end
                if ~isempty(pLOab)
                    r = [pLOab(:).position];
                    x = double(r(1 : 3 : end-2)');
                    y = double(r(2 : 3 : end-1)');
                    index1 = x > cc.modelx.face(i) & x < cc.modelx.face(i+1);
                    index2 = y > cc.modely.face(j) & y < cc.modely.face(j+1);
                    interPhonon = pLOab(index1 & index2);
                    energyLOab = sum([interPhonon(:).energy]);
                end
                if ~isempty(pLOem)
                    r = [pLOem(:).position];
                    x = double(r(1 : 3 : end-2)');
                    y = double(r(2 : 3 : end-1)');
                    index1 = x > cc.modelx.face(i) & x < cc.modelx.face(i+1);
                    index2 = y > cc.modely.face(j) & y < cc.modely.face(j+1);
                    interPhonon = pLOem(index1 & index2);
                    energyLOem = sum([interPhonon(:).energy]);
                end
                if ~isempty(pTOab)
                    r = [pTOab(:).position];
                    x = double(r(1 : 3 : end-2)');
                    y = double(r(2 : 3 : end-1)');
                    index1 = x > cc.modelx.face(i) & x < cc.modelx.face(i+1);
                    index2 = y > cc.modely.face(j) & y < cc.modely.face(j+1);
                    interPhonon = pTOab(index1 & index2);
                    energyTOab = sum([interPhonon(:).energy]);
                end
                if ~isempty(pTOem)
                    r = [pTOem(:).position];
                    x = double(r(1 : 3 : end-2)');
                    y = double(r(2 : 3 : end-1)');
                    index1 = x > cc.modelx.face(i) & x < cc.modelx.face(i+1);
                    index2 = y > cc.modely.face(j) & y < cc.modely.face(j+1);
                    interPhonon = pTOem(index1 & index2);
                    energyTOem = sum([interPhonon(:).energy]);
                end
                % 只能在极化支的频率定义域内进行计算
                if cc.frequency.point(k+1) >= sc.wMinLA && cc.frequency.point(k+1) <= sc.wMaxLA
                    obj.Q(k).LA.data(i+1, j+1) = cc.eleConc.data(i+1, j+1) * (energyLAem - energyLAab) / (cc.superElecs*obj.minimumTime);
                    obj.nDot(k).LA.data(i+1, j+1) = obj.Q(k).LA.data(i+1, j+1) / (pc.hbar*cc.frequency.point(k+1)*sc.dosLA(k+1)*deltaw)*cc.xsfornDot;
                end
                if cc.frequency.point(k+1) >= sc.wMinTA && cc.frequency.point(k+1) <= sc.wMaxTA
                    obj.Q(k).TA.data(i+1, j+1) = cc.eleConc.data(i+1, j+1) * (energyTAem - energyTAab) / (cc.superElecs*obj.minimumTime);
                    obj.nDot(k).TA.data(i+1, j+1) = obj.Q(k).TA.data(i+1, j+1) / (pc.hbar*cc.frequency.point(k+1)*sc.dosTA(k+1)*deltaw)*cc.xsfornDot;
                end
                if cc.frequency.point(k+1) >= sc.wMinLO && cc.frequency.point(k+1) <= sc.wMaxLO
                    obj.Q(k).LO.data(i+1, j+1) = cc.eleConc.data(i+1, j+1) * (energyLOem - energyLOab) / (cc.superElecs*obj.minimumTime);
                    obj.nDot(k).LO.data(i+1, j+1) = obj.Q(k).LO.data(i+1, j+1) / (pc.hbar*cc.frequency.point(k+1)*sc.dosLO(k+1)*deltaw)*cc.xsfornDot;
                end
                if cc.frequency.point(k+1) >= sc.wMinTO && cc.frequency.point(k+1) <= sc.wMaxTO
                    obj.Q(k).TO.data(i+1, j+1) = cc.eleConc.data(i+1, j+1) * (energyTOem - energyTOab) / (cc.superElecs*obj.minimumTime);
                    obj.nDot(k).TO.data(i+1, j+1) = obj.Q(k).TO.data(i+1, j+1) / (pc.hbar*cc.frequency.point(k+1)*sc.dosTO(k+1)*deltaw)*cc.xsfornDot;
                end
            end
        end
    end
    
end
