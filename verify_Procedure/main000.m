%% 验证程序
clc,clear
close all

mm = ModelMeshing;
NX = 20;
NY = 20;
mm.modelXGrid(0, 1, NX);
mm.modelYGrid(0, 1, NY);
% mm.modelMeshingGridPlot;

%% 验证正交网格plotField和computeGradient
% phi = ColocateField(mm);
% gradQ = StaggeredField(mm);
% for i = 1 : mm.NX + 2
%     for j = 1 : mm.NY + 2
%         phi.data(i, j) = mm.modelx.point(i)^2;% + mm.modely.point(j)^2;
%     end
% end
% phi.plotField(mm);
% phi.computeGradient(mm, gradQ);
% gradQ.plotField(mm);
%% 验证交叉网格plotField和computeDivergence
% divU = ColocateField(mm);
% velocity = StaggeredField(mm);
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
% velocity.plotField(mm);
% velocity.plotVectorField(mm);
% velocity.computeDivergence(mm, divU);
% divU.plotField(mm);
%% 扩散项/对流项/源项算子验证
% phi = ColocateField(mm);
% lambda = StaggeredField(mm, 1, 1);
% rho = StaggeredField(mm, 1, 1);
% velocity = StaggeredField(mm, 10, 10);
% massflux = StaggeredField(mm);
% multiplyStaggered(mm, massflux, rho, velocity);
% sp = ColocateField(mm, 0);
% sc = ColocateField(mm, 1);
% eqn = LinearSystem(NX, NY);
% for i = 2 : mm.NX + 1
%     phi.top(i, :) = [0.0    0.0];
%     phi.bottom(i, :) = [0.0    0.0];
% end
% for j = 2 : mm.NY + 1
%     phi.left(j, :) = [0.0    0.0];
%     phi.right(j, :) = [0.0    0.0];
% end
% for k = 1 : 1
%     eqn.initialize;
%     eqn.setInitialGuess(mm, phi);
%     diffusionOperator(eqn, mm, lambda, phi);
%     convectionOperator(eqn, mm, massflux, phi);
%     sourceOperator(eqn, mm, sp, sc);
% %     eqn.displayOneEquation(400);
%     eqn.solveMatrix(500);
%     eqn.updateField(mm, phi);
% end
% phi.plotField(mm)
%% 热点验证
pVelocity = 8e3;
tao = 3e-13;

phi = ColocateField(mm);
lambda = StaggeredField(mm, 1, 1);
rho = StaggeredField(mm, 1, 1);
velocity = StaggeredField(mm, pVelocity, pVelocity);
massflux = StaggeredField(mm);
multiplyStaggered(mm, massflux, rho, velocity);
sp = ColocateField(mm, 1/tao);
sc = ColocateField(mm, 0);
eqn = LinearSystem(NX, NY);
for i = 2 : mm.NX + 1
    phi.top(i, :) = [0.0    0.0];
    phi.bottom(i, :) = [0.0    0.0];
end
for j = 2 : mm.NY + 1
    phi.left(j, :) = [0.0    0.0];
    phi.right(j, :) = [0.0    0.0];
end
sc.data(round(mm.NX/2), round(mm.NY/2)) = -1e14;
for k = 1 : 1
    eqn.initialize;
    eqn.setInitialGuess(mm, phi);
%     diffusionOperator(eqn, mm, lambda, phi);
    convectionOperator(eqn, mm, massflux, phi);
    sourceOperator(eqn, mm, sp, sc);
%     eqn.displayOneEquation(400);
    eqn.solveMatrix(10);
    eqn.updateField(mm, phi);
end
phi.plotField(mm)