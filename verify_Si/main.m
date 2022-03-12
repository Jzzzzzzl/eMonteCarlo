%% 

clc,clear
close all
addpath(genpath(pwd))


pc = PhysicConstants("Si");
cc = ConfigureConstants("1D");
bs = BandStructure("Si");
sc = ScatterringCurve("Si", pc);
sr = ScatterringRateTable("Si", pc, cc);
sh = SimulationHistory(bs, pc, cc);
sp = ScatterringProcess;
mm = ModelMeshing;
pq = PhononQuantityStatics(50);

sh = parallelCompute(sh, bs, sr, sp, sc, pc, cc);

%% 
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
pp.dirftVelocityWithTime(sh, mm, cc, 100);
pp.scatTypeDistribution(sh, cc);
pp.energyDistribution(sh, mm, pc, cc, 100);
pp.averageEnergyWithTime(sh, mm, pc, cc, 100)
% pp.electronTrace(sh, pc, cc, 2, 'k');
% pp.electronTrace(sh, pc, cc, 2, 'r');
% pp.electronTrace(sh, pc, cc, 2, 'e');
%验证5，声子发射谱
% mm.frequencyGrid(0, 1e14, 100);
% pq.subPhononQuantityStatics(sh, mm, sc, cc);
% pq.phononEmSpectrum(mm, sc, pc, "LA")
% pq.phononEmSpectrum(mm, sc, pc, "TA")
% pq.phononEmSpectrum(mm, sc, pc, "LO")
% pq.phononEmSpectrum(mm, sc, pc, "TO")
% pq.phononEmSpectrum(mm, sc, pc, "ALL")









