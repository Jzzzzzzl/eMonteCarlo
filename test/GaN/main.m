%% 
rmpath(genpath('/home/jiang/eMonteCarlo'))
addpath(genpath('./BasicClasses'))
addpath(genpath('./functions/'))
addpath(genpath('./MEX/'))
addpath(genpath('./OperatorTerms/'))
addpath(genpath('./ParallelCompute/MaterialParallelCompute'))
addpath(genpath('./Material_GaN/'))
addpath(genpath('./test/GaN'))

%%
clc,clear
close all
pc = PhysicConstantsGaN;
cc = ConfigureConstantsGaN(pc);
sc = ScatteringCurveGaN(cc, pc);

dv = DecideValleyKind(cc, pc, sc);
sh = SimulationHistory(dv, pc, cc);
eq = ElectricQuantityStaticsGaN;
pq = PhononQuantityStatics(cc);
%%
verifyProgram('verifyConfigureSettings', dv, pc, sc, cc)
parallelCompute(sh, dv, sc, pc, cc);
%% 
eq.minTime = 0e-12;
eq.maxTime = 10e-12;
eq.extractElectricHistoryHard(cc, 300);

eq.plotElectronTrace(cc, 1, 'k')
eq.plotElectronTrace(cc, 1, 'e')
eq.plotElectronTrace(cc, 1, 'r')
%% 
eq.minTime = 0e-12;
eq.maxTime = 10e-12;
eq.maxEnergy = 6*cc.e;
eq.extractElectricHistorySoft(cc, 1000);

eq.computeDirftVelocityWithTimeSoft(cc)
eq.computeDriftVwithEFieldSoft(cc)
eq.computeValleyOccupationWithTime(cc)
eq.computeValleyOccupationWithElectricField(cc)

% eq.statisticsScatteringTypeDistribution('U');
% eq.statisticsScatteringTypeDistribution('G1');
% eq.statisticsScatteringTypeDistribution('G3');

eq.plotGeneralPropertiesSoft(cc);
%%  
pq.minTime = 0e-12;
pq.maxTime = 10e-12;
pq.parallelPhononDistribution(cc);

pq.plotSpectrum(pc, cc, 'ALL', [0, 1e9, 0, 1e9])
%% 
% 验证1，能带画图
dv.valley.bandStructurePlot(pc, pc.hsp.G, pc.hsp.K);
dv.valley.electricVelocityPlot(pc, pc.hsp.G, pc.hsp.K);
% sc.plotScatteringCurve(pc);
%验证2，散射表画图
tic; dv.valley.scatteringRatePlot(sc, pc, cc, [1, 20]); toc
%验证3，验证函数
% verifyProgram("EnergyToVector", dv, pc, sc, cc);
% verifyProgram("youshifangxiangdianchang", dv, pc, sc, cc);
% verifyProgram("AcousticPiezoelectricScatPlot", dv, pc, sc, cc);
% verifyProgram("ValleyStructureOfValleyGamma", dv, pc, sc, cc);
% verifyProgram("ValleyStructureOfValleyU", dv, pc, sc, cc);
% verifyProgram("SingleValleyDrifVelocityWithMaxScatRate", dv, pc, sc, cc);












