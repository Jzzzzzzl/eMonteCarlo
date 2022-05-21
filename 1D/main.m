%% 二维模型主程序
rmpath(genpath('/home/jiang/eMonteCarlo'))
addpath(genpath('./BasicClasses'))
addpath(genpath('./OperatorTerms'))
addpath(genpath('./functions'))
addpath(genpath('./Material_GaN'))
addpath(genpath('./ParallelCompute/DeviceParallelCompute'))
addpath(genpath('./1D/'))

%% 
clc,clear
close all
pc = PhysicConstantsGaN;
cc = ConfigureConstants(pc);
dv = DecideValleyKind(pc);
sc = ScatteringCurve(cc, pc);
sh = SimulationHistory(dv, pc, cc);
pq = PhononQuantityStatics(cc);

%% 
parallelCompute(sh, dv, sc, pc, cc);
eq = ElectricQuantityStaticsGaN(cc);
% pq.minimumTime = eq.minimumTime;
% pq.parallelPhononDistribution(cc);
% pq.computeHeatGenerationRate(pc, cc, sc);
% pq.solveFarDistributionFunction(cc, sc);
% pq.plotnAndnDot(cc);
% pq.computeTF(cc, sc, pc);
% pq.computeTeff(cc, pc, sc)

eq.computeAverageEnergyWithTime(cc, 1000);
eq.statisticsEnergyHistoryDistribution(cc, 1000);
eq.plotGeneralProperties


%% 
eq.plotElectronTrace(cc, 2, 'k');
eq.plotElectronTrace(cc, 1, 'r');
eq.plotElectronTrace(cc, 2, 'e');
eq.plotElectronTrace(cc, 1, 'xy');

%验证5，声子发射谱
% pq.plotSpectrum(pc, cc, "LA");
% pq.plotSpectrum(pc, cc, "TA");
% pq.plotSpectrum(pc, cc, "LO");
% pq.plotSpectrum(pc, cc, "TO");
% pq.plotSpectrum(pc, cc, "ALL");

% cc.dopDensity.plotField(cc);
% cc.eleConc.plotField(cc);
% cc.xField.plotField(cc);
% cc.yField.plotField(cc);
% cc.xyField.plotField(cc);

es = ElectricStatus;
es.position = [cc.modelx.face(end-1)*1.01 0 0];
cc.computeElectricField(es)






