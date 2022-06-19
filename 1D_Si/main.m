%% 二维模型主程序
rmpath(genpath('/home/jiang/eMonteCarlo/'))
addpath(genpath('./BasicClasses/'))
addpath(genpath('./OperatorTerms/'))
addpath(genpath('./functions/'))
addpath(genpath('./Material_Si/'))
addpath(genpath('./ParallelCompute/DeviceParallelCompute/'))
addpath(genpath('./1D_Si/'))

%% 
clc,clear
close all
pc = PhysicConstantsSi;
cc = ConfigureConstantsSi(pc);
dv = DecideValleyKind(pc);
sc = ScatteringCurveSi(cc, pc);

sc.getBandDataFromOther(cc);

sh = SimulationHistory(dv, pc, cc);
pq = PhononQuantityStatics(cc);
%%
verifyProgram('inducedElectricField1D', dv, pc, sc, cc)
verifyProgram('verifyConfigureSettings', dv, pc, sc, cc)
%% 
parallelCompute(sh, dv, sc, pc, cc);
eq = ElectricQuantityStaticsSi(cc);
%%
pq.minTime = 0e-12;
pq.maxTime = 85e-12;
pq.parallelPhononDistribution(cc);
%%
pq.initializeVariables(cc);
pq.computeHeatGenerationRate(pc, cc, sc);
pq.solveFarDistributionFunction(cc, sc);

pq.plotFullFrequencyPeoperties(pq.Q, cc)
pq.plotFullFrequencyPeoperties(pq.nDot, cc)
pq.plotFullFrequencyPeoperties(pq.n, cc)
%% 
pq.computeTF(cc, sc, pc)
pq.computeTeff(cc, pc, sc, 'LA')
pq.computeTeff(cc, pc, sc, 'TA')
pq.computeTeff(cc, pc, sc, 'LO')
pq.computeTeff(cc, pc, sc, 'TO')
pq.computeTeff(cc, pc, sc, 'ALL')

pq.TF.plotField(cc)
pq.pTeff.LA.plotField(cc)
pq.pTeff.TA.plotField(cc)
pq.pTeff.LO.plotField(cc)
pq.pTeff.TO.plotField(cc)
pq.Teff.plotField(cc)
legend("TF", "LATeff", "TATeff", "LOTeff", "TOTeff", "Teff")
%% 
eq.plotElectronTrace(cc, 2, 'k')
eq.plotElectronTrace(cc, 1, 'r')
eq.plotElectronTrace(cc, 9, 'e')
eq.plotElectronTrace(cc, 0, 'd')
eq.plotElectronTrace(cc, 16, 'xy')

%%
pq.plotSpectrum(pc, cc, "LA", [150, 170, 0.1, 99.9])
pq.plotSpectrum(pc, cc, "TA", [150, 170, 0.1, 99.9])
pq.plotSpectrum(pc, cc, "LO", [150, 170, 0.1, 99.9])
pq.plotSpectrum(pc, cc, "TO", [150, 170, 0.1, 99.9])
pq.plotSpectrum(pc, cc, "ALL", [0.1, 150, 0.1, 99.9])
%%
cc.dopDensity.plotField(cc, 'n')
cc.eleConc.plotField(cc)
cc.xFieldCopy.plotField(cc)
cc.yFieldCopy.plotField(cc)
cc.xyField.plotField(cc)

%% 
writeDataToFile('aveEtime', cc, eq.aveEtime)
writeDataToFile('currrent', cc, eq.current)
writeDataToFile('occupyRate', cc, eq.occupyRate)
writeDataToFile('xEfield', cc, cc.modelx.point*1e9, cc.xFieldCopy.data(2:end-1, 2))


%% 
nDot = repmat(pq.polar, cc.NW, 1);
for k = 1 : cc.NW
    nDot(k).LA = pq.nDot(k).LA.data(:, 2);
    nDot(k).TA = pq.nDot(k).TA.data(:, 2);
    nDot(k).LO = pq.nDot(k).LO.data(:, 2);
    nDot(k).TO = pq.nDot(k).TO.data(:, 2);
end

save data cc pc pq sc











