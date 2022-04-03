%% 
addpath(genpath('./BasicClasses'))
addpath(genpath('./functions'))
% addpath(genpath('./Material_Si'))
addpath(genpath('./Material_GaN'))
addpath(genpath('./ParallelCompute'))
addpath(genpath('./PostProcess'))

%%
clc,clear
close all
pc = PhysicConstants;
cc = ConfigureConstants;
dv = DecideValleyKind(pc);
sc = ScatterringCurve(pc);
sh = SimulationHistory(dv, pc, cc);
mm = ModelMeshing;
pq = PhononQuantityStatics(pc, 50);

%% 
sh = parallelCompute(sh, dv, sc, pc, cc);
ep = ElectricQuantityStatics(sh, cc);

% 验证1，能带画图
% dv.bs.bandStructurePlot(50, pc);
% dv.bs.electricVelocityPlot(50, pc);
%验证2，散射表画图
% tic; scatteringRatePlot(dv, sc, pc, cc); toc
%验证3，波矢选择及能量相互验证
% verifyProgram("chooseWaveVectorForGamma", dv, pc, cc);
% verifyProgram("chooseWaveVector", dv, pc, cc);
% verifyProgram("EnergyToVector", dv, pc, cc);
% verifyProgram("AcousticPiezoelectricScat", dv, pc, cc);
%验证4，数据后处理
% ep.dirftVelocityWithTime(sh, mm, cc, 40, 100);
% ep.scatTypeDistribution(sh, cc);
% ep.energyDistribution(sh, mm, cc, 0.5, 100);
% ep.averageEnergyWithTime(sh, mm, cc, 2, 100);
% ep.electronTrace(sh, cc, 1, 'k');
% ep.electronTrace(sh, cc, 1, 'r');
% ep.electronTrace(sh, cc, 1, 'e');
%验证5，声子发射谱
% pq.subPhononQuantityStatics(sh, mm);
% pq.phononSpectrumPlot(mm, pc, "LA");
% pq.phononSpectrumPlot(mm, pc, "TA");
% pq.phononSpectrumPlot(mm, pc, "LO");
% pq.phononSpectrumPlot(mm, pc, "TO");
% pq.phononSpectrumPlot(mm, pc, "ALL");

