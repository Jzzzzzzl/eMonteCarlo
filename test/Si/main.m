%% 硅性质验证程序
rmpath(genpath('/home/jiang/eMonteCarlo'))
addpath(genpath('./BasicClasses/'))
addpath(genpath('./functions/'))
addpath(genpath('./MEX/'))
addpath(genpath('./OperatorTerms/'))
addpath(genpath('./ParallelCompute/MaterialParallelCompute'))
addpath(genpath('./Material_Si/'))
addpath(genpath('./test/Si'))

%%
clc,clear
close all
pc = PhysicConstantsSi;
cc = ConfigureConstantsSi(pc);
sc = ScatteringCurveSi(cc, pc);

sc.getBandDataFromOther(cc);

dv = DecideValleyKind(cc, pc, sc);
sh = SimulationHistory(dv, pc, cc);
eq = ElectricQuantityStaticsSi;
pq = PhononQuantityStatics(cc);
%%
verifyProgram('verifyConfigureSettings', dv, pc, sc, cc)
parallelCompute(sh, dv, sc, pc, cc);
% %% 
% eq.minTime = 0e-12;
% eq.maxTime = 30e-12;
% eq.extractElectricHistoryHard(cc, 100);
% 
% eq.plotElectronTrace(cc, 1, 'k')
% eq.plotElectronTrace(cc, 12, 'e')
% eq.plotElectronTrace(cc, 1, 'r')
%% 
eq.minTime = 0e-12;
eq.maxTime = 250e-12;
eq.maxEnergy = 2*cc.e;
eq.extractElectricHistorySoft(cc, 100);
eq.computeDirftVelocityWithTimeSoft(cc);

eq.plotGeneralPropertiesSoft(cc);
% eq.statisticsScatteringTypeDistribution;
%% 
pq.minTime = 0e-12;
pq.maxTime = 30e-12;
pq.parallelPhononDistribution(cc);
%% 
% 验证1，能带画图
dv.valley.bandStructurePlot(pc, pc.hsp.G, pc.hsp.X);
dv.valley.electricVelocityPlot(pc, pc.hsp.G, pc.hsp.X);
% sc.plotScatteringCurve(pc);
%验证2，散射表画图
tic; dv.valley.scatteringRatePlot(sc, pc, cc, [1, 20]); toc
%验证3，验证函数
% verifyProgram("EnergyToVector", dv, pc, sc, cc);
% verifyProgram("youshifangxiangdianchang", dv, pc, sc, cc);
% verifyProgram("AcousticPiezoelectricScatPlot", dv, pc, sc, cc);
% verifyProgram("ValleyStructureOfValleyGamma", dv, pc, sc, cc);
% verifyProgram("ValleyStructureOfValleyU", dv, pc, sc, cc);
%验证5，声子发射谱
pq.plotSpectrum(pc, cc, 'LA', [0, 1e9, 0, 1e9])
pq.plotSpectrum(pc, cc, 'TA', [0, 1e9, 0, 1e9])
pq.plotSpectrum(pc, cc, 'LO', [0, 1e9, 0, 1e9])
pq.plotSpectrum(pc, cc, 'TO', [0, 1e9, 0, 1e9])
pq.plotSpectrum(pc, cc, 'ALL', [0, 1e9, 0, 1e9])





















