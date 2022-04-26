%% 
rmpath(genpath('/home/jiang/eMonteCarlo'))
addpath(genpath('./BasicClasses'))
addpath(genpath('./OperatorTerms'))
addpath(genpath('./functions'))
addpath(genpath('./Material_GaN'))
addpath(genpath('./MaterialParallelCompute'))
addpath(genpath('./PostProcess'))
addpath(genpath('./test/GaN'))

%%
clc,clear
close all
pc = PhysicConstantsGaN;
cc = ConfigureConstants;
dv = DecideValleyKind(pc);
sc = ScatteringCurve(cc, pc);
sh = SimulationHistory(dv, pc, cc);
pq = PhononQuantityStatics(cc);

%% 
sh = parallelCompute(sh, dv, sc, pc, cc);
eq = ElectricQuantityStaticsGaN(sh, pc, cc);
pq.minimumTime = eq.minimumTime;
% 验证1，能带画图
% dv.valley.bandStructurePlot(pc, pc.hsp.L, pc.hsp.M);
% dv.valley.electricVelocityPlot(pc, pc.hsp.L, pc.hsp.M);
%验证2，散射表画图
% tic; dv.valley.scatteringRatePlot(sc, pc, cc, [1, 15]); toc
%验证3，验证函数
% verifyProgram("EnergyToVector", dv, pc, sc, cc);
% verifyProgram("AcousticPiezoelectricScatPlot", dv, pc, sc, cc);
% verifyProgram("ValleyStructureOfValleyGamma", dv, pc, sc, cc);
% verifyProgram("ValleyStructureOfValleyU", dv, pc, sc, cc);
%验证4，数据后处理
eq.pulsesFieldDirftVelocityWithTime(sh, cc, 100);
eq.waveVectorDistribution(sh, pc, cc, [0.0e-12 0.1e-12 5]);
% eq.scatTypeDistribution(sh, cc);
% eq.energyHistoryDistribution(sh, cc, 5, 100);
eq.averageEnergyWithTime(sh, cc, 100);
% eq.valleyOccupationWithTime(sh, cc, 100);
% eq.electronTrace(sh, cc, 20, 'k');
% eq.electronTrace(sh, cc, 35, 'r');
% eq.electronTrace(sh, cc, 14, 'e');
%验证5，声子发射谱
% pq.subPhononQuantityStatics(sh, cc);
% pq.plotSpectrum(pc, cc, "LA");
% pq.plotSpectrum(pc, cc, "TA");
% pq.plotSpectrum(pc, cc, "LO");
% pq.plotSpectrum(pc, cc, "TO");
% pq.plotSpectrum(pc, cc, "ALL");


% figure
% slg = plot(eq.aveDriftVelocity(2:end, 1)*1e12, eq.aveDriftVelocity(2:end, 2)*100);
% slg.LineWidth = 2;
% xlabel("ps");ylabel("cm/s");
% legend("drift velocity")
% 
% eq.electronTrace(sh, cc, 40, 'v');












