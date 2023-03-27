%% 材料计算主程序
rmpath(genpath('/home/jiang/eMonteCarlo'))
addpath(genpath('./BasicClasses/'))
addpath(genpath('./functions/'))
addpath(genpath('./MEX/'))
addpath(genpath('./OperatorTerms/'))
addpath(genpath('./ParallelCompute/MaterialParallelCompute'))
addpath(genpath('./Material_Si/'))
addpath(genpath('./test/Si'))
%% 初始化计算对象
clc,clear
close all
pc = PhysicConstantsSi;
cc = ConfigureConstantsSi(pc);
sc = ScatteringCurveSi(cc, pc);
% 采用shengBTE的数据,若不采用则注释该行
sc.getBandDataFromOther(cc);

dv = DecideValleyKind(cc, pc, sc);
sh = SimulationHistory(dv, pc, cc);
eq = ElectricQuantityStaticsSi;
pq = PhononQuantityStatics(cc);
%% 开始计算
verifyProgram('verifyConfigureSettings', dv, pc, sc, cc)
parallelCompute(sh, dv, sc, pc, cc);
%% Hard读取仅用于观察电子轨迹图
eq.minTime = 0e-12;
eq.maxTime = 15e-12;
eq.extractElectricHistoryHard(cc, 100, 1);
% 电子轨迹图
eq.plotElectronTrace(cc, 1, 'k')
eq.plotElectronTrace(cc, 12, 'e')
eq.plotElectronTrace(cc, 1, 'r')
%% Soft读取仅用于计算电子性质
eq.minTime = 0e-12;
eq.maxTime = 15e-12;
eq.maxEnergy = 2*cc.e;
eq.extractElectricHistorySoft(cc, 100);
% 材料性质
eq.computeDirftVelocityWithTimeSoft(cc);
eq.computeDriftVwithEFieldSoft(cc);
eq.plotGeneralPropertiesSoft(cc);
% 电子散射类型统计
eq.statisticsScatteringTypeDistribution;
%% 读取声子历史信息
pq.minTime = 0e-12;
pq.maxTime = 15e-12;
pq.parallelPhononDistribution(cc);
%% 电声散射结果验证
% 验证1，能带/色散曲线画图
dv.valley.bandStructurePlot(pc, pc.hsp.G, pc.hsp.X);
dv.valley.electricVelocityPlot(pc, pc.hsp.G, pc.hsp.X);
sc.plotScatteringCurve(pc);
% 验证2，散射表画图
tic; dv.valley.scatteringRatePlot(sc, pc, cc, [1, 20]); toc
% 验证3，验证函数
verifyProgram('EnergyToVector', dv, pc, sc, cc);
verifyProgram('youshifangxiangdianchang', dv, pc, sc, cc);
% 验证4，声子发射谱
pq.plotSpectrum(pc, cc, 'LA', [0, 1e9, 0, 1e9])
pq.plotSpectrum(pc, cc, 'TA', [0, 1e9, 0, 1e9])
pq.plotSpectrum(pc, cc, 'LO', [0, 1e9, 0, 1e9])
pq.plotSpectrum(pc, cc, 'TO', [0, 1e9, 0, 1e9])
pq.plotSpectrum(pc, cc, 'ALL', [0, 1e9, 0, 1e9])

%% 散射率导出
sa = zeros(1001, 7);
temp = dv.valleyGX.interScatable';
sa(:, 1) = dv.valleyGX.energyFace;
sa(:, 2) = temp(:, 1);
sa(:, 3) = temp(:, 2);
sa(:, 4) = temp(:, 7);
sa(:, 5) = temp(:, 9);
sa(:, 6) = temp(:, 12);
sa(:, 7) = temp(:, 17);

%% 单电子轨迹图导出
tempk = zeros(2000, 3);
for i = 1 : 2000
    tempk(i, :) = eq.vectors(:, :, 1, i);
end














