%% 

clc,clear
close all
addpath(genpath(pwd))


pc = PhysicConstants("Si");
cc = ConfigureConstants("1D");
sc = ScatterringCurve("Si", pc);
bs = BandStructure("Si");
sr = ScatterringRateTable("Si", pc, cc);
sh = SimulationHistory(bs, pc, cc);
sp = ScatterringProcess;
pp = PostProcessing;
mm = ModelMeshing;
pq = PhononQuantityStatics(50);

sh = ParallelCompute(sh, bs, sr, sp, sc, pc, cc);

% mm.FrequencyGrid(0, 1e14, 100);
% mm.TimeGrid(0, 500 * 1e-12, 100);
% mm.EnergyGrid(0, 2, 100);

% pp.AverageTotalFlyTime(sh, cc);
% pp.ElectronDirftVelocity(sh, cc);
% pp.DirftVelocityWithTime(sh, mm, cc);
% pp.ScatTypeDistribution(sh, cc);
% pp.EnergyDistribution(sh, mm, pc, cc);
% pp.ElectronTrace(sh, pc, cc, 2, 'k');
% pp.ElectronTrace(sh, pc, cc, 2, 'r');
% pp.ElectronTrace(sh, pc, cc, 2, 'e');
% pp.AverageEnergyWithTime(sh, mm, pc, cc)

pq.SubPhononQuantityStatics(sh, mm, sc, cc);
pq.PhononEmSpectrum(mm, sc, pc, "LA")
pq.PhononEmSpectrum(mm, sc, pc, "TA")
pq.PhononEmSpectrum(mm, sc, pc, "LO")
pq.PhononEmSpectrum(mm, sc, pc, "TO")
pq.PhononEmSpectrum(mm, sc, pc, "ALL")





% es = bs.ChooseWaveVector(es, pc);

% es.energy = 1.2 * pc.e;
% sr.ScatterringTable(es, sc, pc, cc);
% sr.ComputeFlyTime;
% sr.flyTime
% sr.ScatterringRatePlot(sc, pc, cc);




% VerifyProgram("EnergyToVector", bs, pc);

% es = es.ComputeInParabolicFactor(pc);
% es.energy = bs.ComputeElectricEnergy(es, pc);
% es.velocity = bs.ComputeElectricVelocity(es, pc);
% % es.valley = es.RandomValley("i");
% % disp(es)


% bs.BandStructurePlot(50, pc);
% bs.ElectricVelocityPlot(50, pc);



