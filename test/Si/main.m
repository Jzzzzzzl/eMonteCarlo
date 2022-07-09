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
%% 
parallelCompute(sh, dv, sc, pc, cc);
eq.minTime = 0e-12;
eq.maxTime = 15e-12;
eq.maxEnergy = 2*cc.e;
eq.extractElectricHistoryInformation(cc, 300);

eq.plotGeneralProperties(cc);
eq.statisticsScatteringTypeDistribution(cc);
%% 
pq.minTime = 0e-12;
pq.maxTime = 15e-12;
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
pq.plotSpectrum(pc, cc, 'LA', [0, 320, 0, 100])
pq.plotSpectrum(pc, cc, 'TA', [0, 320, 0, 100])
pq.plotSpectrum(pc, cc, 'LO', [0, 320, 0, 100])
pq.plotSpectrum(pc, cc, 'TO', [0, 320, 0, 100])
pq.plotSpectrum(pc, cc, 'ALL', [0, 320, 0, 100])


