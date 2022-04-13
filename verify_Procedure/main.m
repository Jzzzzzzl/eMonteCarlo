%% 
% rmpath(genpath(pwd))
% addpath(genpath('./BasicClasses'))
% addpath(genpath('./diffusion term'))
% addpath(genpath('./functions'))
% % addpath(genpath('./Material_Si'))
% addpath(genpath('./Material_GaN'))
% addpath(genpath('./ParallelCompute'))
% addpath(genpath('./PostProcess'))

%%
% clc,clear
% close all
% pc = PhysicConstants;
% cc = ConfigureConstants;
% dv = DecideValleyKind(pc);
% sc = ScatterringCurve(pc);
% sh = SimulationHistory(dv, pc, cc);
% 
% mm = ModelMeshing;
% pq = PhononQuantityStatics(pc, 50);

%% 
% sh = parallelCompute(sh, dv, sc, pc, cc);
% eq = ElectricQuantityStaticsGaN(sh, pc, cc);
% eq = ElectricQuantityStaticsSi(sh, pc, cc);
% 验证1，能带画图
% dv.valley.bandStructurePlot(pc, pc.hsp.G, pc.hsp.M);
% dv.valley.electricVelocityPlot(pc, pc.hsp.G, pc.hsp.M);
%验证2，散射表画图
% tic; dv.valley.scatteringRatePlot(sc, pc, cc, [1, 12]); toc
%验证3，验证函数
% verifyProgram("EnergyToVector", dv, pc, sc, cc);
% verifyProgram("AcousticPiezoelectricScatPlot", dv, pc, sc, cc);
% verifyProgram("ValleyStructureOfValleyGamma", dv, pc, sc, cc);
% verifyProgram("ValleyStructureOfValleyU", dv, pc, sc, cc);
%验证4，数据后处理
% eq.dirftVelocityWithTime(sh, mm, cc, 100);
% eq.scatTypeDistribution(sh, cc);
% eq.energyHistoryDistribution(sh, mm, cc, 5, 100);
% eq.averageEnergyWithTime(sh, mm, cc, 100);
% eq.valleyOccupationWithTime(sh, mm, cc, 10);
% eq.electronTrace(sh, cc, 20, 'k');
% eq.electronTrace(sh, cc, 15, 'r');
% eq.electronTrace(sh, cc, 114, 'e');
%验证5，声子发射谱
% pq.subPhononQuantityStatics(sh, mm);
% pq.phononSpectrumPlot(mm, pc, "LA");
% pq.phononSpectrumPlot(mm, pc, "TA");
% pq.phononSpectrumPlot(mm, pc, "LO");
% pq.phononSpectrumPlot(mm, pc, "TO");
% pq.phononSpectrumPlot(mm, pc, "ALL");

%% 
clc,clear
close all

mm = ModelMeshing;
NX = 50;
NY = 50;
mm.modelXGrid(0, 1, NX);
mm.modelYGrid(0, 1, NY);
% mm.modelMeshingGridPlot;
phi = ColocateField(mm);
rho = StaggeredField(mm, 1, 1);
velocity = StaggeredField(mm, 1, 1);
massflux = StaggeredField(mm);
multiplyStaggered(mm, massflux, rho, velocity);

sc = ColocateField(mm, 0.1);
lambda = StaggeredField(mm, 2, 2);
eqn = LinearSystem(NX, NY);

for i = 2 : mm.NX + 1
    phi.top(i, :) = [1.0    0.0];
    phi.bottom(i, :) = [0.0    0.0];
end
for j = 2 : mm.NY + 1
    phi.left(j, :) = [0.0    1.0];
    phi.right(j, :) = [1.0    0.0];
end
for i = 1 : 20
    eqn.initialize;
    eqn.setInitialGuess(mm, phi);
    diffusionOperator(eqn, mm, lambda, phi);
    convectionOperator(eqn, mm, massflux, phi);
    sourceOperator(eqn, mm, sc);
%     eqn.displayOneEquation(395);
    eqn.relax(0.9);
    eqn.solveMatrix(50);
    eqn.updateField(mm, phi);
end



% diffusionOperator(eqn, mm, lambda, phi);
% eqn.displayOneEquation(395);

% sourceOperator(eqn, mm, sc);
% eqn.solveMatrix(1000)
% eqn.updateField(mm, phi);
phi.plotField(mm)






% grandv = ColocateField(mm);
% velocity = StaggeredField(mm);
% 
% for i = 1 : NX + 1
%     for j = 1 : NY + 2
%         velocity.datax(i, j) = mm.modelx.face(i) * mm.modely.point(j);
%     end
% end
% for i = 1 : NX + 2
%     for j = 1 : NY + 1
%         velocity.datay(i, j) = mm.modely.face(j)^2 / 2;
%     end
% end
% velocity.plotFieldX(mm);
% velocity.plotFieldY(mm);
% velocity.plotVectorField(mm);

% velocity.computeDivergence(mm);










