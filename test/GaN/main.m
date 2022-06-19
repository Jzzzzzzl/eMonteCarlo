%% 
rmpath(genpath('/home/jiang/eMonteCarlo'))
addpath(genpath('./BasicClasses'))
addpath(genpath('./OperatorTerms'))
addpath(genpath('./functions'))
addpath(genpath('./Material_GaN'))
addpath(genpath('./ParallelCompute/MaterialParallelCompute'))
addpath(genpath('./test/GaN'))

%%
clc,clear
close all
pc = PhysicConstantsGaN;
cc = ConfigureConstantsGaN(pc);
dv = DecideValleyKind(pc);
sc = ScatteringCurveGaN(cc, pc);
sh = SimulationHistory(dv, pc, cc);
pq = PhononQuantityStatics(cc);

%%
verifyProgram('verifyConfigureSettings', dv, pc, sc, cc)
%% 
parallelCompute(sh, dv, sc, pc, cc);
eq = ElectricQuantityStaticsGaN(cc);
% pq.minTime = 0e-12;
% pq.maxTime = 14e-12;
% pq.parallelPhononDistribution(cc);
% 验证1，能带画图
% dv.valley.bandStructurePlot(pc, pc.hsp.L, pc.hsp.M);
% dv.valley.electricVelocityPlot(pc, pc.hsp.G, pc.hsp.K);
% sc.plotScatteringCurve(pc);
%验证2，散射表画图
tic; dv.valley.scatteringRatePlot(sc, pc, cc, [1, 20]); toc
%验证3，验证函数
% verifyProgram("EnergyToVector", dv, pc, sc, cc);
% verifyProgram("youshifangxiangdianchang", dv, pc, sc, cc);
% verifyProgram("AcousticPiezoelectricScatPlot", dv, pc, sc, cc);
% verifyProgram("ValleyStructureOfValleyGamma", dv, pc, sc, cc);
% verifyProgram("ValleyStructureOfValleyU", dv, pc, sc, cc);
% verifyProgram("SingleValleyDrifVelocityWithMaxScatRate", dv, pc, sc, cc);

%验证4，数据后处理
eq.computeAllProperties(dv, pc, cc);
eq.plotGeneralProperties;

% eq.statisticsScatteringTypeDistribution(cc, 'U');
% eq.statisticsScatteringTypeDistribution(cc, 'G1');
% eq.statisticsScatteringTypeDistribution(cc, 'G3');
eq.computeValleyOccupationWithTime(cc, 1000);
eq.computeValleyOccupationWithElectricField(cc);
% eq.plotElectronTrace(cc, 2, 'k');
% eq.plotElectronTrace(cc, 5, 'r');
% eq.plotElectronTrace(cc, 8, 'e');



%% 
% writeDataToFile('aveEtime', cc, eq.aveEtime)
% writeDataToFile('driftVfield', cc, eq.driftVfield)
% writeDataToFile('occupyField', cc, eq.occupyField)
% writeDataToFile('enumbers', cc, eq.enumbers)
% writeDataToFile('occupyRate', cc, eq.occupyRate)
% writeDataToFile('driftVtime', cc, eq.driftVtime)










