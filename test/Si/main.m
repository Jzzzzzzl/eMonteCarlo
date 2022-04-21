%% 
rmpath(genpath('/home/jiang/eMonteCarlo'))
addpath(genpath('./BasicClasses'))
addpath(genpath('./OperatorTerms'))
addpath(genpath('./functions'))
addpath(genpath('./Material_Si'))
addpath(genpath('./ParallelCompute'))
addpath(genpath('./PostProcess'))
addpath(genpath('./test/Si'))

%%
clc,clear
close all
pc = PhysicConstantsSi;
cc = ConfigureConstants;
dv = DecideValleyKind(pc);
sc = ScatteringCurve(cc, pc);
sh = SimulationHistory(dv, pc, cc);
pq = PhononQuantityStatics(cc);

%% 
sh = parallelCompute(sh, dv, sc, pc, cc);
eq = ElectricQuantityStaticsSi(sh, pc, cc);
pq.minimumTime = eq.minimumTime;
% 验证1，能带画图
dv.valley.bandStructurePlot(pc, pc.hsp.G, pc.hsp.X);
dv.valley.electricVelocityPlot(pc, pc.hsp.G, pc.hsp.X);
%验证2，散射表画图
tic; dv.valley.scatteringRatePlot(sc, pc, cc, [1, 18]); toc
%验证3，验证函数
verifyProgram("EnergyToVector", dv, pc, sc, cc);
% verifyProgram("AcousticPiezoelectricScatPlot", dv, pc, sc, cc);
% verifyProgram("ValleyStructureOfValleyGamma", dv, pc, sc, cc);
% verifyProgram("ValleyStructureOfValleyU", dv, pc, sc, cc);
%验证4，数据后处理
eq.dirftVelocityWithTime(sh, cc, 100);
eq.scatTypeDistribution(sh, cc);
eq.energyHistoryDistribution(sh, cc, 0.5, 100);
eq.averageEnergyWithTime(sh, cc, 100);
% eq.valleyOccupationWithTime(sh, mm, cc, 10);
eq.electronTrace(sh, cc, 20, 'k');
eq.electronTrace(sh, cc, 15, 'r');
eq.electronTrace(sh, cc, 14, 'e');
%验证5，声子发射谱
pq.subPhononQuantityStatics(sh, cc);
pq.plotSpectrum(pc, cc, "LA");
pq.plotSpectrum(pc, cc, "TA");
pq.plotSpectrum(pc, cc, "LO");
pq.plotSpectrum(pc, cc, "TO");
pq.plotSpectrum(pc, cc, "ALL");


















