%% 二维模型主程序
rmpath(genpath('/home/jiang/eMonteCarlo/'))
addpath(genpath('./BasicClasses/'))
addpath(genpath('./functions/'))
addpath(genpath('./MEX/'))
addpath(genpath('./OperatorTerms/'))
addpath(genpath('./ParallelCompute/DeviceParallelCompute/'))
addpath(genpath('./Material_Si/'))
addpath(genpath('./2D_Si/'))
rmpath(genpath('./2D_Si/Silvaco Script/'))
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
eq.maxTime = 100e-12;
eq.extractElectricHistoryHard(cc, 1000, 0);
% 电子轨迹图
eq.plotElectronTrace(cc, 2, 'k')
eq.plotElectronTrace(cc, 8, 'r')
eq.plotElectronTrace(cc, 1, 'e')
eq.plotElectronTrace(cc, 0, 'd')
eq.plotElectronTrace(cc, 2, 'xy')
%% Soft读取仅用于计算电子性质
eq.minTime = 0e-12;
eq.maxTime = 200e-12;
eq.maxEnergy = 6*cc.e;
eq.extractElectricHistorySoft(cc, 100);
% 通过平均性质的变化来判断是否收敛
eq.computeDirftVelocityWithTimeSoft(cc);
eq.plotGeneralPropertiesSoft(cc);
% 电子散射类型统计
eq.statisticsScatteringTypeDistribution;
%% 读取声子历史信息并求解BTE
pq.minTime = 0e-12;
pq.maxTime = 200e-12;
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

gradTF = StaggeredField(cc);
pq.TF.computeGradient(cc, gradTF);
gradTF.datax = gradTF.datax * (-pc.k);
gradTF.plotField(cc)
X = cc.modelx.face*1e9;
Y = cc.modely.point*1e9;
writeDataToFile2D('gradTFx', cc, X, Y, gradTF.datax);
X = cc.modelx.point*1e9;
Y = cc.modely.face*1e9;
writeDataToFile2D('gradTFy', cc, X, Y, gradTF.datay);

pq.TF.plotField(cc, 'n')
pq.pTeff.LA.plotField(cc, 'n')
pq.pTeff.TA.plotField(cc, 'n')
pq.pTeff.LO.plotField(cc, 'n')
pq.pTeff.TO.plotField(cc, 'n')
pq.Teff.plotField(cc, 'n')

% 截线图
figure
hold on
A = cc.modelx.point(2:end-1)*1e9;
B = pq.pTeff.LA.data(2:cc.NX+1, cc.NY+1);
C = pq.pTeff.LO.data(2:cc.NX+1, cc.NY+1);
D = pq.Teff.data(2:cc.NX+1, cc.NY+1);
E = pq.TF.data(2:cc.NX+1, cc.NY+1);
plot(A, [B C D E])
plot(pq.TF.data(2:cc.NX+1, cc.NY+1))
plot(pq.pTeff.LO.data(2:cc.NX+1, cc.NY+1))
plot(cc.latticeTem.data(2:cc.NX+1, cc.NY+1 ))
legend(["TF" "LOTeff" "latticeTem"])
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
cc.heatConduc.plotField(cc, 'n')
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
