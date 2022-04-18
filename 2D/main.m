%% 二维模型主程序
clc,clear
close all

rmpath(genpath('/home/jiang/eMonteCarlo')); clc
addpath(genpath('./2D/'))
addpath(genpath('./BasicClasses'))
addpath(genpath('./OperatorTerms'))
addpath(genpath('./functions'))
addpath(genpath('./Material_Si'))
addpath(genpath('./ParallelCompute'))
addpath(genpath('./PostProcess'))

%% 
pc = PhysicConstants;
cc = ConfigureConstants;
dv = DecideValleyKind(pc);
sc = ScatterringCurve(pc);
sh = SimulationHistory(dv, pc, cc);
pq = PhononQuantityStatics(pc, cc);

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

%% 
eq.dirftVelocityWithTime(sh, cc, 100);
eq.scatTypeDistribution(sh, cc);
eq.energyHistoryDistribution(sh, cc, 0.5, 100);
eq.averageEnergyWithTime(sh, cc, 100);

eq.electronTrace(sh, cc, 20, 'k');
eq.electronTrace(sh, cc, 15, 'r');
eq.electronTrace(sh, cc, 14, 'e');
eq.electronTrace(sh, cc, 5, 'xy');

%验证5，声子发射谱
pq.subPhononQuantityStatics(sh, cc);
pq.phononSpectrumPlot(pc, cc, "LA");
pq.phononSpectrumPlot(pc, cc, "TA");
pq.phononSpectrumPlot(pc, cc, "LO");
pq.phononSpectrumPlot(pc, cc, "TO");
pq.phononSpectrumPlot(pc, cc, "ALL");

cc.dopDensity.plotField(cc);
cc.eleConc.plotField(cc);
cc.xField.plotField(cc);
cc.yField.plotField(cc);
cc.xyField.plotField(cc);
