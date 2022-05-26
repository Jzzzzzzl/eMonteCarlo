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
% verifyProgram('inducedElectricField1D', dv, pc, sc, cc)
verifyProgram('verifyConfigureSettings', dv, pc, sc, cc)
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
eq.computeValleyOccupationWithTime(cc, 1000);
eq.computeTerminalCurrent(cc)
%% 
eq.plotElectronTrace(cc, 2, 'k');
eq.plotElectronTrace(cc, 1, 'r');
eq.plotElectronTrace(cc, 2, 'e');
eq.plotElectronTrace(cc, 0, 'd')
eq.plotElectronTrace(cc, 15, 'xy');

%验证5，声子发射谱
% pq.plotSpectrum(pc, cc, "LA");
% pq.plotSpectrum(pc, cc, "TA");
% pq.plotSpectrum(pc, cc, "LO");
% pq.plotSpectrum(pc, cc, "TO");
% pq.plotSpectrum(pc, cc, "ALL");

cc.dopDensity.plotField(cc);
cc.eleConc.plotField(cc);
cc.xFieldCopy.plotField(cc);
cc.yFieldCopy.plotField(cc);
cc.xyField.plotField(cc);

tGrid = linspace(8, 18, 3)*1e-12;
figure
hold on
for t = 1 : length(tGrid)
    denEles = zeros(cc.NX, 1);
    for i = 1 : cc.superElecs
        indext = find(eq.times(i, :) > tGrid(t), 1);
        xPosition = eq.positions(:, 1, i, indext);
        index = find(cc.modelx.face > xPosition, 1) - 1;
        denEles(index) = denEles(index) + 1;
    end
    slg = plot(denEles);
    slg.LineWidth = 2;
end
n = size(denEles);
legend(sprintfc('%g', linspace(1, n(2) - 1, n(2) - 1)))

%% 
writeDataToFile('aveEtime', cc, eq.aveEtime)
writeDataToFile('currrent', cc, eq.current)
writeDataToFile('occupyRate', cc, eq.occupyRate)
writeDataToFile('xEfield', cc, cc.modelx.point*1e9, cc.xField.data(2:end-1, 2))










