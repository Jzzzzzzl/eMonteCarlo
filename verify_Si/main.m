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

sh = parallelCompute(sh, bs, sr, sp, sc, pc, cc);

pp = PostProcessing;
mm = ModelMeshing;
pq = PhononQuantityStatics(50);

mm.frequencyGrid(0, 1e14, 100);
mm.timeGrid(0, 1000 * 1e-12, 100);
mm.energyGrid(0, 2, 100);


%验证1，能带画图
% bs.bandStructurePlot(50, pc);
% bs.electricVelocityPlot(50, pc);
%验证2，散射表画图
% es.energy = 1.2 * pc.e;
% sr.scatterringTable(es, sc, pc, cc);
% sr.computeFlyTime;
% sr.flyTime
% sr.computeScatType
% sr.scatType
% sr.scatterringRatePlot(sc, pc, cc);
%验证3，波矢选择及能量相互验证
% verifyProgram("EnergyToVector", bs, pc);
%验证4，数据后处理
pp.averageTotalFlyTime(sh, cc);
pp.electronDirftVelocity(sh, cc);
pp.dirftVelocityWithTime(sh, mm, cc);
pp.scatTypeDistribution(sh, cc);
pp.energyDistribution(sh, mm, pc, cc);
% pp.electronTrace(sh, pc, cc, 2, 'k');
% pp.electronTrace(sh, pc, cc, 2, 'r');
% pp.electronTrace(sh, pc, cc, 2, 'e');
% pp.averageEnergyWithTime(sh, mm, pc, cc)













% pq.subPhononQuantityStatics(sh, mm, sc, cc);
% pq.phononEmSpectrum(mm, sc, pc, "LA")
% pq.phononEmSpectrum(mm, sc, pc, "TA")
% pq.phononEmSpectrum(mm, sc, pc, "LO")
% pq.phononEmSpectrum(mm, sc, pc, "TO")
% pq.phononEmSpectrum(mm, sc, pc, "ALL")











