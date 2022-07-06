%% 二维模型主程序
rmpath(genpath('/home/jiang/eMonteCarlo/'))
addpath(genpath('./BasicClasses/'))
addpath(genpath('./OperatorTerms/'))
addpath(genpath('./functions/'))
addpath(genpath('./MEX/'))
addpath(genpath('./Material_Si/'))
addpath(genpath('./ParallelCompute/DeviceParallelCompute/'))
addpath(genpath('./1D_Si/'))

%% 
clc,clear
close all
pc = PhysicConstantsSi;
cc = ConfigureConstantsSi(pc);
sc = ScatteringCurveSi(cc, pc);

sc.getBandDataFromOther(cc);

dv = DecideValleyKind(cc, pc, sc);
sh = SimulationHistory(dv, pc, cc);
pq = PhononQuantityStatics(cc);
%%
verifyProgram('verifyConfigureSettings', dv, pc, sc, cc)
%% 
parallelCompute(sh, dv, sc, pc, cc);
% eq = ElectricQuantityStaticsSi(cc);
% 
% eq.computeAverageEnergyWithPosition(cc);
% eq.aveEPos.plotField(cc, 'n')
%%
pq.minTime = 100e-12;
pq.maxTime = 350e-12;
pq.parallelPhononDistribution(cc);
%%
pq.initializeVariables(cc);
pq.computeHeatGenerationRate(pc, cc, sc);
pq.solveFarDistributionFunction(cc, sc);


pq.plotFullFrequencyPeoperties(pq.Q, cc)
pq.plotFullFrequencyPeoperties(pq.nDot, cc)
pq.plotFullFrequencyPeoperties(pq.n, cc)
%% 
pq.computeTF(cc, sc, pc)
pq.computeTeff(cc, pc, sc, 1)
pq.computeTeff(cc, pc, sc, 2)
pq.computeTeff(cc, pc, sc, 3)
pq.computeTeff(cc, pc, sc, 4)
pq.computeTeff(cc, pc, sc, 5)

pq.TF.plotField(cc)
pq.pTeff.LA.plotField(cc)
pq.pTeff.TA.plotField(cc)
pq.pTeff.LO.plotField(cc)
pq.pTeff.TO.plotField(cc)
pq.Teff.plotField(cc)
legend("TF", "LATeff", "TATeff", "LOTeff", "TOTeff", "Teff")
%% 
eq.plotElectronTrace(cc, 2, 'k')
eq.plotElectronTrace(cc, 8, 'r')
eq.plotElectronTrace(cc, 1, 'e')
eq.plotElectronTrace(cc, 0, 'd')
eq.plotElectronTrace(cc, 6, 'xy')

%%
pq.plotSpectrum(pc, cc, 'LA', [170, 172, 0.1, 99.9])
pq.plotSpectrum(pc, cc, 'TA', [170, 172, 0.1, 99.9])
pq.plotSpectrum(pc, cc, 'LO', [170, 172, 0.1, 99.9])
pq.plotSpectrum(pc, cc, 'TO', [170, 172, 0.1, 99.9])
pq.plotSpectrum(pc, cc, 'ALL', [0.1, 320, 0.1, 99.9])

eq.statisticsScatteringTypeDistribution(cc)
%%
cc.dopDensity.plotField(cc, 'n')
cc.eleConc.plotField(cc, 'n')
cc.xField.plotField(cc, 'n')
cc.yField.plotField(cc, 'n')
cc.xyField.plotField(cc, 'n')

% %% 
% writeDataToFile('aveEtime', cc, eq.aveEtime)
% writeDataToFile('currrent', cc, eq.current)
% writeDataToFile('occupyRate', cc, eq.occupyRate)
% writeDataToFile('xEfield', cc, cc.modelx.point*1e9, cc.xFieldCopy.data(2:end-1, 2))
% 
% %% 
% nDot = repmat(pq.polar, cc.NW, 1);
% for k = 1 : cc.NW
%     nDot(k).LA = pq.nDot(k).LA.data(:, 2);
%     nDot(k).TA = pq.nDot(k).TA.data(:, 2);
%     nDot(k).LO = pq.nDot(k).LO.data(:, 2);
%     nDot(k).TO = pq.nDot(k).TO.data(:, 2);
% end
%%
N = zeros(cc.NX, cc.NY);
p = 1;
for i = 1 : cc.NW
    N = N + pq.allSumF(:, :, p, i);
end
plot(N*cc.hbar/cc.e)
%% 
n = ColocateField(cc);
ndot = ColocateField(cc);
x = linspace(0, 20, cc.NX)';
ndot.data(2:end-1, 2) = normpdf(x, 10, 1/sqrt(2*pi))*5e13 + 1e13;
deltax = 320e-9/cc.NX;
deltay = 100e-9/cc.NY;
nTemp1 = solven(ndot.data, deltax, deltay, 3000, 0, 10e-12);
nTemp2 = solven(ndot.data, deltax, deltay, -3000, 0, 10e-12);
nTemp = (nTemp1 + nTemp2)/2;
hold on
plot(nTemp1(:, 2))
plot(nTemp2(:, 2))
plot(nTemp(:, 2))
legend("n1", "n2", "n1+n2")
%% 
clc,close all
tao = 10e-12;
vr = 3000;
vt = 1000;
a = 20e-9;

x = linspace(0, 20, cc.NX);
ndot = normpdf(x, 0, 1/sqrt(2*pi))*5e14 + 5e13;
n1 = @(r) ndot.*tao.*(1 - exp((-r.*vr+sqrt(a.^2*(vr.^2+vt.^2) - r.^2.*vt.^2))./(tao.*(vr.^2+vt.^2))));
n2 = @(r) 2*ndot.*tao.*exp(-r.*vr./(tao.*(vr.^2+vt.^2))).*sinh(sqrt(a.^2*(vr.^2+vt.^2) - r.^2.*vt.^2)./(tao.*(vr.^2+vt.^2)));
r = linspace(0, 300, cc.NX)*1e-9;

hold on
plot(r, n1(r))
plot(r, n2(r))
plot(r, n1(r)+n2(r))
legend("n1", "n2", "n1+n2")












