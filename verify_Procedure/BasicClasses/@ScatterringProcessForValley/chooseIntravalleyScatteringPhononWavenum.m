function chooseIntravalleyScatteringPhononWavenum(obj, dv, pc, cc)
    %>选择谷内散射声子波数
    obj.qAB = dv.sr.xAB*pc.kb*cc.envTemp / (pc.hbar*pc.u);
    obj.qEM = dv.sr.xEM*pc.kb*cc.envTemp / (pc.hbar*pc.u);
end