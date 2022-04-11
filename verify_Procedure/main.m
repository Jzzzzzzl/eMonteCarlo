%% 
% rmpath(genpath(pwd))
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
eq = ElectricQuantityStaticsGaN(sh, pc, cc);
% eq = ElectricQuantityStaticsSi(sh, pc, cc);
% 验证1，能带画图
% dv.valley.bandStructurePlot(pc);
% dv.valley.electricVelocityPlot(pc);
%验证2，散射表画图
% tic; dv.valley.scatteringRatePlot(sc, pc, cc, [1, 12]); toc
%验证3，验证函数
% verifyProgram("EnergyToVector", dv, pc, sc, cc);
% verifyProgram("AcousticPiezoelectricScatPlot", dv, pc, sc, cc);
% verifyProgram("ValleyStructureOfValleyGamma", dv, pc, sc, cc);
% verifyProgram("ValleyStructureOfValleyU", dv, pc, sc, cc);
%验证4，数据后处理
eq.dirftVelocityWithTime(sh, mm, cc, 100);
% eq.scatTypeDistribution(sh, cc);
% eq.energyHistoryDistribution(sh, mm, cc, 5, 100);
eq.averageEnergyWithTime(sh, mm, cc, 100);
eq.valleyOccupationWithTime(sh, mm, cc, 10);
eq.electronTrace(sh, cc, 20, 'k');
% eq.electronTrace(sh, cc, 15, 'r');
% eq.electronTrace(sh, cc, 114, 'e');
%验证5，声子发射谱
% pq.subPhononQuantityStatics(sh, mm);
% pq.phononSpectrumPlot(mm, pc, "LA");
% pq.phononSpectrumPlot(mm, pc, "TA");
% pq.phononSpectrumPlot(mm, pc, "LO");
% pq.phononSpectrumPlot(mm, pc, "TO");
% pq.phononSpectrumPlot(mm, pc, "ALL");


es = ElectricStatus;
es.valley = 4;
es.vector = [-7.6335   -9.5250    7.0339]*1e9;
dv.valleyGuidingPrinciple(es);
dv.valley.computeEnergyAndGroupVelocity(es, pc);
disp(es.energy)






























