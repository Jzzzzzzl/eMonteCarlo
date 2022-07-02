%% 硅性质验证程序
rmpath(genpath('/home/jiang/eMonteCarlo'))
addpath(genpath('./BasicClasses'))
addpath(genpath('./OperatorTerms'))
addpath(genpath('./functions'))
addpath(genpath('./Material_Si'))
addpath(genpath('./ParallelCompute/MaterialParallelCompute'))
addpath(genpath('./test/Si'))

%%
clc,clear
close all
pc = PhysicConstantsSi;
cc = ConfigureConstantsSi(pc);
dv = DecideValleyKind(pc);
sc = ScatteringCurveSi(cc, pc);
sh = SimulationHistory(dv, pc, cc);
pq = PhononQuantityStatics(cc);

%%
verifyProgram('verifyConfigureSettings', dv, pc, sc, cc)
%% 
parallelCompute(sh, dv, sc, pc, cc);
eq = ElectricQuantityStaticsSi(cc);
% pq.minTime = 0e-12;
% pq.maxTime = 14e-12;
% pq.parallelPhononDistribution(cc);
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
%验证4，数据后处理
eq.computeAllProperties(dv, pc, cc);
eq.plotGeneralProperties;
% eq.statisticsScatteringTypeDistribution(cc);

eq.plotElectronTrace(cc, 20, 'k');
eq.plotElectronTrace(cc, 3, 'r');
eq.plotElectronTrace(cc, 2, 'e');
%验证5，声子发射谱
% pq.plotSpectrum(pc, cc, "LA", [150, 170, 0.1, 99.9])
% pq.plotSpectrum(pc, cc, "TA", [150, 170, 0.1, 99.9])
% pq.plotSpectrum(pc, cc, "LO", [150, 170, 0.1, 99.9])
% pq.plotSpectrum(pc, cc, "TO", [150, 170, 0.1, 99.9])
% pq.plotSpectrum(pc, cc, "ALL", [0.1, 150, 0.1, 99.9])











