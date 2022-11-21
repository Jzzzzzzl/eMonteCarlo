%% 二维模型主程序
rmpath(genpath('/home/jiang/eMonteCarlo/'))
addpath(genpath('./BasicClasses/'))
addpath(genpath('./functions/'))
addpath(genpath('./MEX/'))
addpath(genpath('./OperatorTerms/'))
addpath(genpath('./ParallelCompute/DeviceParallelCompute/'))
addpath(genpath('./Material_GaN/'))
addpath(genpath('./2D_GaN/'))
%% 初始化计算对象
clc,clear
close all
pc = PhysicConstantsGaN;
cc = ConfigureConstantsGaN(pc);
sc = ScatteringCurveGaN(cc, pc);
% 采用shengBTE的数据,若不采用则注释该行
sc.getBandDataFromOther(cc);

dv = DecideValleyKind(cc, pc, sc);
sh = SimulationHistory(dv, pc, cc);
eq = ElectricQuantityStaticsGaN;
pq = PhononQuantityStatics(cc);
%% 开始计算
verifyProgram('verifyConfigureSettings', dv, pc, sc, cc)
parallelCompute(sh, dv, sc, pc, cc);
%% Hard读取仅用于观察电子轨迹图
eq.minTime = 0e-12;
eq.maxTime = 180e-12;
eq.extractElectricHistoryHard(cc, 1000, 1);
% 电子轨迹图
eq.plotElectronTrace(cc, 2, 'k')
eq.plotElectronTrace(cc, 8, 'r')
eq.plotElectronTrace(cc, 1, 'e')
eq.plotElectronTrace(cc, 0, 'd')
eq.plotElectronTrace(cc, 12, 'xy')
%% Soft读取仅用于计算电子性质
eq.minTime = 0e-12;
eq.maxTime = 130e-12;
eq.maxEnergy = 6*cc.e;
eq.extractElectricHistorySoft(cc, 100);
% 通过平均性质的变化来判断是否收敛
eq.computeDirftVelocityWithTimeSoft(cc);
eq.plotGeneralPropertiesSoft(cc);
% 电子散射类型统计
eq.statisticsScatteringTypeDistribution(cc, 'U');
eq.statisticsScatteringTypeDistribution(cc, 'G1');
eq.statisticsScatteringTypeDistribution(cc, 'G3');
%% 读取声子历史信息并求解BTE
pq.minTime = 50e-12;
pq.maxTime = 180e-12;
pq.parallelPhononDistribution(cc);
pq.initializeVariables(cc);
pq.computeHeatGenerationRate(pc, cc, sc);
pq.solveFarDistributionFunction(cc, sc);

pq.plotFullFrequencyPeoperties(pq.Q, cc, 'Q')
pq.plotFullFrequencyPeoperties(pq.nDot, cc, 'nDot')
pq.plotFullFrequencyPeoperties(pq.n, cc, 'n')
%% 计算扩散及等效温度
pq.computeTF(cc, sc, pc)
pq.computeTeff(cc, pc, sc, 1)
pq.computeTeff(cc, pc, sc, 2)
pq.computeTeff(cc, pc, sc, 3)
pq.computeTeff(cc, pc, sc, 4)
pq.computeTeff(cc, pc, sc, 5)

pq.TF.plotField(cc, 'n')
pq.pTeff.LA.plotField(cc, 'n')
pq.pTeff.TA.plotField(cc, 'n')
pq.pTeff.LO.plotField(cc, 'n')
pq.pTeff.TO.plotField(cc, 'n')
pq.Teff.plotField(cc, 'n')
%% 声子发射谱
pq.plotSpectrum(pc, cc, 'LA', [0, cc.mLength, 0, cc.mWidth]*1e9)
pq.plotSpectrum(pc, cc, 'TA', [0, cc.mLength, 0, cc.mWidth]*1e9)
pq.plotSpectrum(pc, cc, 'LO', [0, cc.mLength, 0, cc.mWidth]*1e9)
pq.plotSpectrum(pc, cc, 'TO', [0, cc.mLength, 0, cc.mWidth]*1e9)
pq.plotSpectrum(pc, cc, 'ALL', [0, cc.mLength, 0, cc.mWidth]*1e9)
%% 根据TCAD结果调整xsforQ和xsforSourceB
cc.dopDensity.plotField(cc, 'n')
cc.eleConc.plotField(cc, 'n')
cc.xField.plotField(cc, 'n')
cc.yField.plotField(cc, 'n')
cc.xyField.plotField(cc, 'n')
cc.potential.plotField(cc, 'n')
cc.latticeTem.plotField(cc, 'n')
cc.jouleHeat.plotField(cc, 'n')
cc.conducBand.plotField(cc, 'n')
cc.eMobility.plotField(cc, 'n')
%>写入文件
cc.writeTCADtoFile
%% 其他需要输出的参数

%% 输出电声散射源项
nDot = repmat(pq.polar, cc.NW, 1);
for k = 1 : cc.NW
    nDot(k).LA = pq.nDot(k).LA.data(:, 2);
    nDot(k).TA = pq.nDot(k).TA.data(:, 2);
    nDot(k).LO = pq.nDot(k).LO.data(:, 2);
    nDot(k).TO = pq.nDot(k).TO.data(:, 2);
end






