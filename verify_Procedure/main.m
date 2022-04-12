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

grandv = ColocateField(mm);
velocity = StaggeredField(mm);

for i = 1 : NX + 1
    for j = 1 : NY + 2
        velocity.datax(i, j) = mm.modelx.face(i) * mm.modely.point(j);
    end
end
for i = 1 : NX + 2
    for j = 1 : NY + 1
        velocity.datay(i, j) = mm.modely.face(j)^2 / 2;
    end
end
% velocity.plotFieldX(mm)
% velocity.plotFieldY(mm)
% velocity.plotVectorField(mm)
% 
% velocity.computeDivergence(mm)

% eqn = LinearSystem(2, 2);
% eqn.matrix(1) = 3;
% eqn.matrix(2) = -1;
% eqn.matrix(3) = 1;
% eqn.matrix(4) = 1;
% eqn.matrix(5) = 3;
% eqn.matrix(6) = -1;
% eqn.matrix(7) = -1;
% eqn.matrix(8) = 2;
% eqn.matrix(9) = -1;
% eqn.matrix(10) = 1;
% eqn.matrix(11) = 1;
% eqn.matrix(12) = 4;
% 
% eqn.b(1) = 1;
% eqn.b(2) = 8;
% eqn.b(3) = 0;
% eqn.b(4) = -2;
% 
% eqn.solveMatrix(50);
% disp(eqn.result)












