%% 二维模型主程序
rmpath(genpath('/home/jiang/eMonteCarlo/'))
addpath(genpath('./BasicClasses/'))
addpath(genpath('./functions/'))
addpath(genpath('./MEX/'))
addpath(genpath('./OperatorTerms/'))
addpath(genpath('./ParallelCompute/DeviceParallelCompute/'))
addpath(genpath('./Material_GaN/'))
addpath(genpath('./1D_GaN/'))
%% 
clc,clear
close all
pc = PhysicConstantsGaN;
cc = ConfigureConstantsGaN(pc);
sc = ScatteringCurveGaN(cc, pc);

% sc.getBandDataFromOther(cc);

dv = DecideValleyKind(cc, pc, sc);
sh = SimulationHistory(dv, pc, cc);
eq = ElectricQuantityStaticsGaN;
pq = PhononQuantityStatics(cc);
%%
verifyProgram('verifyConfigureSettings', dv, pc, sc, cc)
parallelCompute(sh, dv, sc, pc, cc);
%% 
eq.minTime = 0e-12;
eq.maxTime = 130e-12;
eq.maxEnergy = 6*cc.e;
eq.extractElectricHistorySoft(cc, 1000);

eq.computeDirftVelocityWithTimeSoft(cc)
eq.computeValleyOccupationWithTime(cc)

% eq.statisticsScatteringTypeDistribution('U');
% eq.statisticsScatteringTypeDistribution('G1');
% eq.statisticsScatteringTypeDistribution('G3');

eq.plotGeneralPropertiesSoft(cc);
plot(cc.modelx.point(2:end-1)*1e9, eq.aveEPos/cc.e)
%%
pq.minTime = 0e-12;
pq.maxTime = 130e-12;
pq.parallelPhononDistribution(cc);

pq.initializeVariables(cc);
pq.computeHeatGenerationRate(pc, cc, sc);
pq.solveFarDistributionFunction(cc, sc);

pq.plotFullFrequencyPeoperties(pq.Q, cc, 'Q')
pq.plotFullFrequencyPeoperties(pq.nDot, cc, 'nDot')
pq.plotFullFrequencyPeoperties(pq.n, cc, 'n')
%% 
pq.computeTF(cc, sc, pc)
pq.computeTeff(cc, pc, sc, 1)
pq.computeTeff(cc, pc, sc, 2)
pq.computeTeff(cc, pc, sc, 3)
pq.computeTeff(cc, pc, sc, 4)
pq.computeTeff(cc, pc, sc, 5)

pq.TF.plotField(cc)
pq.pTeff.LA.plotField(cc)
pq.pTeff.TA.plotField(cc)
pq.pTeff.LO.plotField(cc)
pq.pTeff.TO.plotField(cc)
pq.Teff.plotField(cc)
legend("TF", "LATeff", "TATeff", "LOTeff", "TOTeff", "Teff")

%>写入文件
writeDataToFile1D('TF', cc, cc.modelx.point(2:end-1)*1e9, pq.TF.data(2:end-1, cc.NY+1));
writeDataToFile1D('LATeff', cc, cc.modelx.point(2:end-1)*1e9, pq.pTeff.LA.data(2:end-1, cc.NY+1));
writeDataToFile1D('TATeff', cc, cc.modelx.point(2:end-1)*1e9, pq.pTeff.TA.data(2:end-1, cc.NY+1));
writeDataToFile1D('LOTeff', cc, cc.modelx.point(2:end-1)*1e9, pq.pTeff.LO.data(2:end-1, cc.NY+1));
writeDataToFile1D('TOTeff', cc, cc.modelx.point(2:end-1)*1e9, pq.pTeff.TO.data(2:end-1, cc.NY+1));
%% 
eq.plotElectronTrace(cc, 2, 'k')
eq.plotElectronTrace(cc, 8, 'r')
eq.plotElectronTrace(cc, 1, 'e')
eq.plotElectronTrace(cc, 0, 'd')
eq.plotElectronTrace(cc, 6, 'xy')
%%
pq.plotSpectrum(pc, cc, 'LA', [0, 300, 0, 100])
pq.plotSpectrum(pc, cc, 'TA', [0, 300, 0, 100])
pq.plotSpectrum(pc, cc, 'LO', [0, 300, 0, 100])
pq.plotSpectrum(pc, cc, 'TO', [0, 300, 0, 100])
pq.plotSpectrum(pc, cc, 'ALL', [0, 600, 0, 100])

eq.statisticsScatteringTypeDistribution('G1')
eq.statisticsScatteringTypeDistribution('G3')
eq.statisticsScatteringTypeDistribution('U')
%%
cc.dopDensity.plotField(cc, 'n')
cc.eleConc.plotField(cc, 'n')
cc.xField.plotField(cc, 'n')
cc.yField.plotField(cc, 'n')
cc.xyField.plotField(cc, 'n')
%% 
writeDataToFile1D('aveEtime', cc, eq.aveEtime(:, 1), eq.aveEtime(:, 2))
writeDataToFile1D('xEfield', cc, cc.modelx.point(2:end-1)*1e9, cc.xField.data(2:end-1, 2))
%% 
nDot = repmat(pq.polar, cc.NW, 1);
for k = 1 : cc.NW
    nDot(k).LA = pq.nDot(k).LA.data(:, 2);
    nDot(k).TA = pq.nDot(k).TA.data(:, 2);
    nDot(k).LO = pq.nDot(k).LO.data(:, 2);
    nDot(k).TO = pq.nDot(k).TO.data(:, 2);
end

