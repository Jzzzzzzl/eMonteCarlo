%% 

clc,clear
close all
addpath(genpath('./BasicClasses'))
addpath(genpath('./functions'))
addpath(genpath('./Material_Si'))
addpath(genpath('./ParallelCompute'))
addpath(genpath('./PostProcess'))

pc = PhysicConstants;
cc = ConfigureConstants;
dv = DecideValleyKind(pc, cc);
sc = ScatterringCurve(pc);
sh = SimulationHistory(dv, pc, cc);
mm = ModelMeshing;
pq = PhononQuantityStatics(pc, 50);
%% 
sh = parallelCompute(sh, dv, sc, pc, cc);

pp = PostProcessing(sh, cc);

% 验证1，能带画图
% bs.bandStructurePlot(50, pc);
% bs.electricVelocityPlot(50, pc);
%验证2，散射表画图
% es = ElectricStatus;
% es.energy = 0.01 * pc.e;
% sr.scatterringTable(es, sc, pc, cc);
% sr.computeFlyTime;
% sr.flyTime
% sr.computeScatType
% sr.scatType
% sr.scatterringRatePlot(sc, pc, cc);
%验证3，波矢选择及能量相互验证
% verifyProgram("EnergyToVector", bs, pc);
%验证4，数据后处理
% pp.dirftVelocityWithTime(sh, mm, cc, 60, 100);
% pp.scatTypeDistribution(sh, cc);
% pp.energyDistribution(sh, mm, cc, 100);
% pp.averageEnergyWithTime(sh, mm, cc, 2, 100);
% pp.electronTrace(sh, cc, 950, 'k');
% pp.electronTrace(sh, cc, 950, 'r');
% pp.electronTrace(sh, cc, 950, 'e');
%验证5，声子发射谱
% pq.subPhononQuantityStatics(sh, mm, cc);
% pq.phononEmSpectrumPlot(mm, pc, "LA");
% pq.phononEmSpectrumPlot(mm, pc, "TA");
% pq.phononEmSpectrumPlot(mm, pc, "LO");
% pq.phononEmSpectrumPlot(mm, pc, "TO");
% pq.phononEmSpectrumPlot(mm, pc, "ALL");








