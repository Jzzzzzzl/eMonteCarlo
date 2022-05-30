%% 二维模型主程序
rmpath(genpath('/home/jiang/eMonteCarlo'))
addpath(genpath('./BasicClasses'))
addpath(genpath('./OperatorTerms'))
addpath(genpath('./functions'))
addpath(genpath('./Material_Si'))
addpath(genpath('./ParallelCompute/DeviceParallelCompute'))
addpath(genpath('./1D_Si/'))

%% 
clc,clear
close all
pc = PhysicConstantsSi;
cc = ConfigureConstants(pc);
dv = DecideValleyKind(pc);
sc = ScatteringCurve(cc, pc);

sc.getBandDataFromOther(cc);

sh = SimulationHistory(dv, pc, cc);
pq = PhononQuantityStatics(cc);
%%
verifyProgram('inducedElectricField1D', dv, pc, sc, cc)
verifyProgram('verifyConfigureSettings', dv, pc, sc, cc)
%% 
parallelCompute(sh, dv, sc, pc, cc);
eq = ElectricQuantityStaticsSi(cc);
pq.minimumTime = eq.minimumTime;
pq.parallelPhononDistribution(cc);

pq.initializeVariables(cc);
pq.computeHeatGenerationRate(pc, cc, sc);
pq.solveFarDistributionFunction(cc, sc);

pq.plotFullFrequencyPeoperties(pq.n, cc)
pq.plotFullFrequencyPeoperties(pq.Q, cc)
pq.plotFullFrequencyPeoperties(pq.nDot, cc)

pq.computeTF(cc, sc, pc)
pq.computeTeff(cc, pc, sc)
pq.TF.plotField(cc)
pq.Teff.plotField(cc)
hold on
plot(cc.modelx.point(2:end-1), pq.TF.data(2:end-1, 2))
% eq.computeAverageEnergyWithTime(cc, 1000);
% eq.statisticsEnergyHistoryDistribution(cc, 1000);
% eq.computeDirftVelocityWithTime(cc, 300);
% eq.plotGeneralProperties
% eq.computeValleyOccupationWithTime(cc, 1000);
% eq.computeTerminalCurrent(cc)
% eq.statisticsScatteringTypeDistribution(cc);

%% 
eq.plotElectronTrace(cc, 2, 'k');
eq.plotElectronTrace(cc, 1, 'r');
eq.plotElectronTrace(cc, 2, 'e');
eq.plotElectronTrace(cc, 0, 'd')
eq.plotElectronTrace(cc, 156, 'xy');

%验证5，声子发射谱
pq.plotSpectrum(pc, cc, "LA");
pq.plotSpectrum(pc, cc, "TA");
pq.plotSpectrum(pc, cc, "LO");
pq.plotSpectrum(pc, cc, "TO");
pq.plotSpectrum(pc, cc, "ALL");

cc.dopDensity.plotField(cc);
cc.eleConc.plotField(cc);
cc.xFieldCopy.plotField(cc);
cc.yFieldCopy.plotField(cc);
cc.xyField.plotField(cc);

%% 
writeDataToFile('aveEtime', cc, eq.aveEtime)
writeDataToFile('currrent', cc, eq.current)
writeDataToFile('occupyRate', cc, eq.occupyRate)
writeDataToFile('xEfield', cc, cc.modelx.point*1e9, cc.xFieldCopy.data(2:end-1, 2))


%% 
nDot = repmat(pq.polar, cc.NW, 1);
for k = 1 : cc.NW
    nDot(k).LA = pq.nDot(k).LA.data(:, 2);
    nDot(k).TA = pq.nDot(k).TA.data(:, 2);
    nDot(k).LO = pq.nDot(k).LO.data(:, 2);
    nDot(k).TO = pq.nDot(k).TO.data(:, 2);
end
frequency = cc.frequency.point(2:end-1);
%%
energyLA = 0; energyTA = 0;
energyLO = 0; energyTO = 0;
nT = 20;
T = linspace(200, 1000, nT);
n = linspace(-10, 30, nT);
E = zeros(nT, 4);
for m = 1 : nT
    for k = 2 : cc.NW
        deltaw = cc.frequency.face(k+1) - cc.frequency.face(k);
        NLeft = 1 / (exp(pc.hbar*cc.frequency.point(k+1) / (pc.kb*T(m))) - 1) + n(m);
        if sc.gvLA(k+1) ~= 0
            energyLA = energyLA + NLeft*pc.hbar*cc.frequency.point(k+1)*deltaw / sc.gvLA(k+1);
        end
        if sc.gvTA(k+1) ~= 0
            energyTA = energyTA + NLeft*pc.hbar*cc.frequency.point(k+1)*deltaw / sc.gvTA(k+1);
        end
        if sc.gvLO(k+1) ~= 0
            energyLO = energyLO + NLeft*pc.hbar*cc.frequency.point(k+1)*deltaw / sc.gvLO(k+1);
        end
        if sc.gvTO(k+1) ~= 0
            energyTO = energyTO + NLeft*pc.hbar*cc.frequency.point(k+1)*deltaw / sc.gvTO(k+1);
        end
    end
    E(m, 1) = energyLA;
    E(m, 2) = energyTA;
    E(m, 3) = energyLO;
    E(m, 4) = energyTO;
end
figure
hold on
for i = 1 : 4
    loglog(T, E(:, i), 'LineWidth', 2);
end
legend(["LA" "TA" "LO" "TO"])


xsize = 2;
ysize = 3;
[globalID] = getGlobalID(xsize, ysize, 2, 1);
[xID, yID] = getInverseGlobalID(xsize, ysize, globalID)




























