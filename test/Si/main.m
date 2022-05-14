%% 
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
cc = ConfigureConstants(pc);
dv = DecideValleyKind(pc);
sc = ScatteringCurve(cc, pc);
sh = SimulationHistory(dv, pc, cc);
pq = PhononQuantityStatics(cc);

%% 
parallelCompute(sh, dv, sc, pc, cc);
elog = fopen('/home/jiang/documents/eMdatas/ElectronLog.dat');
plog = fopen('/home/jiang/documents/eMdatas/PhononLog.dat');
eq = ElectricQuantityStaticsSi(elog, cc);
pq.minimumTime = eq.minimumTime;
pq.extractPhononHistoryInformation(plog, cc);
% 验证1，能带画图
dv.valley.bandStructurePlot(pc, pc.hsp.G, pc.hsp.X);
% dv.valley.electricVelocityPlot(pc, pc.hsp.G, pc.hsp.X);
%验证2，散射表画图
tic; dv.valley.scatteringRatePlot(sc, pc, cc, [1, 18]); toc
%验证3，验证函数
% verifyProgram("EnergyToVector", dv, pc, sc, cc);
% verifyProgram("AcousticPiezoelectricScatPlot", dv, pc, sc, cc);
% verifyProgram("ValleyStructureOfValleyGamma", dv, pc, sc, cc);
% verifyProgram("ValleyStructureOfValleyU", dv, pc, sc, cc);
%验证4，数据后处理
eq.computeAverageEnergyWithTime(cc, 1000);
eq.computeDiffusionCoefficientWithTime(cc, 300);
eq.computeDiffusionCoefficientWithElectricField(cc);
eq.computeDirftVelocityWithTime(cc, 1000);
eq.computeDriftVelocityWithElectricField(cc);
eq.computeMobilityWithTime(cc, pc);
eq.computeMobilityWithElectricField(cc);
eq.statisticsEnergyHistoryDistribution(cc, 1000);
eq.statisticsWaveVectorDistribution(dv, pc, cc, [0.01e-12 0.01e-12 3]);
eq.plotGeneralProperties;
eq.statisticsScatteringTypeDistribution(cc);

eq.plotElectronTrace(cc, 20, 'k');
eq.plotElectronTrace(cc, 15, 'r');
eq.plotElectronTrace(cc, 2, 'e');
%验证5，声子发射谱
pq.subPhononQuantityStatics(sh, cc);
pq.plotSpectrum(pc, cc, "LA");
pq.plotSpectrum(pc, cc, "TA");
pq.plotSpectrum(pc, cc, "LO");
pq.plotSpectrum(pc, cc, "TO");
pq.plotSpectrum(pc, cc, "ALL");



stringline = "1 2 3 em ab non";
dataline = textscan(stringline, '%f %f %f %s %s %s');
index = isequal(dataline{6}, "non")


