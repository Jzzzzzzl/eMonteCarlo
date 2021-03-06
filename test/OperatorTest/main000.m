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
phi = ColocateField(mm);
lambda = StaggeredField(mm, 1, 1);
rho = StaggeredField(mm, 1, 1);
velocity = StaggeredField(mm, 10, 10);
massflux = StaggeredField(mm);
multiplyStaggered(mm, massflux, rho, velocity);
sp = ColocateField(mm, 0);
sc = ColocateField(mm, -1);
eqn = LinearSystem(NX, NY);
for i = 2 : mm.NX + 1
    phi.top(i, :) = [1.0    0.0];
    phi.bottom(i, :) = [1.0    0.0];
end
for j = 2 : mm.NY + 1
    phi.left(j, :) = [0.0    0.0];
    phi.right(j, :) = [0.0    1.0];
end
for k = 1 : 100
    eqn.initialize;
    eqn.setInitialGuess(mm, phi);
    diffusionOperator(eqn, mm, lambda, phi);
%     convectionOperator(eqn, mm, massflux, phi);
    sourceOperator(eqn, mm, sp, sc);
%     eqn.displayOneEquation(400);
    eqn.solveMatrix(500);
    eqn.updateField(mm, phi);
end
phi.plotField(mm)
% hold on
% f = @(x) x.^2/2 + x/2;
% plot(mm.modelx.point(:), f(mm.modelx.point(:)))
%% 热点验证
% pVelocity = 8e3;
% tao = 3.6e-12;
% 
% phi = ColocateField(mm);
% % lambda = StaggeredField(mm, 1, 1);
% rho = StaggeredField(mm, 1, 1);
% velocity = StaggeredField(mm, pVelocity, pVelocity);
% massflux = StaggeredField(mm);
% multiplyStaggered(mm, massflux, rho, velocity);
% sp = ColocateField(mm, 1/tao);
% sc = ColocateField(mm, 0);
% eqn = LinearSystem(NX, NY);
% for i = 2 : mm.NX + 1
%     phi.top(i, :) = [0.0    0.0];
%     phi.bottom(i, :) = [0.0    0.0];
% end
% for j = 2 : mm.NY + 1
%     phi.left(j, :) = [0.0    0.0];
%     phi.right(j, :) = [0.0    0.0];
% end
% sc.data(round(mm.NX/2), round(mm.NY/2)+1) = -1e14;
% for k = 1 : 10
%     eqn.initialize;
%     eqn.setInitialGuess(mm, phi);
% %     diffusionOperator(eqn, mm, lambda, phi);
%     convectionOperator(eqn, mm, massflux, phi);
%     sourceOperator(eqn, mm, sp, sc);
% %     eqn.displayOneEquation(400);
%     eqn.solveMatrix(1000);
%     eqn.updateField(mm, phi);
% end
% phi.plotField(mm)

% nDot = ColocateField(mm);
% nDot.data(round(mm.NX/2), round(mm.NY/2)+1) = 1e14;
% solven(phi, nDot, mm, pVelocity, tao)
% phi.plotField(mm)
%%

%% 一维电势场求解
% e = 1.602176634e-19;
% kb = 1.380649e-23;
% epsilon0 = 8.854187817e-12;
% epsilonL = 11.9;
% T = 300;
% 
% Nd1 = 1e20 * 1e6;
% Nd2 = 1e16 * 1e6;
% ni = 1.5e16 * 1e6;
% deltaE1 = 0.055 * e;
% deltaE2 = 0.225 * e;
% 
% phi = ColocateField(mm);
% lambda = StaggeredField(mm, 1, 1);
% sp = ColocateField(mm);
% sc = ColocateField(mm);
% eqn = LinearSystem(NX, NY);
% 
% load Eleconc.dat
% index = find(Eleconc(:, 2) == 5e-4);
% eleconc = Eleconc(index, 1:2:3);
% eleconc = [eleconc; 0.3, 1e19];
% plot(eleconc)
% 
% 
% %>源项
% % for i = 1 : mm.NX / 3
% %     n = Nd1/2 + sqrt(Nd1^2/2 + ni^2);
% %     NdPlus = Nd1 - Nd1 / (1+exp((deltaE1)/(kb*T))/2);
% %     sc.data(i + 1, mm.NY+1) = -4*pi/(epsilon0*epsilonL)*e*(n - NdPlus);
% % end
% % for i = mm.NX/3 + 1 : mm.NX*2 / 3
% %     n = Nd2/2 + sqrt(Nd2^2/2 + ni^2);
% %     NdPlus = Nd2 - Nd2 / (1+exp((deltaE2)/(kb*T))/2);
% %     sc.data(i + 1, mm.NY+1) = -4*pi/(epsilon0*epsilonL)*e*(n - NdPlus);
% % end
% % for i = mm.NX*2 / 3 + 1 : mm.NX
% %     n = Nd1/2 + sqrt(Nd1^2/2 + ni^2);
% %     NdPlus = Nd1 - Nd1 / (1+exp((deltaE1)/(kb*T))/2);
% %     sc.data(i + 1, mm.NY+1) = -4*pi/(epsilon0*epsilonL)*e*(n - NdPlus);
% % end
% % for i = 1 : 100
% %     n = eleconc(i, 2);
% %     sc.data(i + 1, mm.NY+1) = -4*pi/(epsilon0*epsilonL)*e*n;
% % %     NdPlus = Nd1 - Nd1 / (1+exp((deltaE1)/(kb*T))/2);
% % %     sc.data(i + 1, mm.NY+1) = -4*pi/(epsilon0*epsilonL)*e*(n - NdPlus);
% % end
% % for i = 101 : 200
% %     n = eleconc(i, 2);
% %     sc.data(i + 1, mm.NY+1) = 4*pi/(epsilon0*epsilonL)*e*n;
% % %     NdPlus = Nd2 - Nd2 / (1+exp((deltaE2)/(kb*T))/2);
% % %     sc.data(i + 1, mm.NY+1) = -4*pi/(epsilon0*epsilonL)*e*(n - NdPlus);
% % end
% % for i = 201 : 300
% %     n = eleconc(i, 2);
% %     sc.data(i + 1, mm.NY+1) = -4*pi/(epsilon0*epsilonL)*e*n;
% % %     NdPlus = Nd1 - Nd1 / (1+exp((deltaE1)/(kb*T))/2);
% % %     sc.data(i + 1, mm.NY+1) = -4*pi/(epsilon0*epsilonL)*e*(n - NdPlus);
% % end
% %>边界条件
% for i = 2 : mm.NX + 1
%     phi.top(i, :) = [1.0    0.0];
%     phi.bottom(i, :) = [1.0    0.0];
% end
% for j = 2 : mm.NY + 1
%     phi.left(j, :) = [0.0    0.0];
%     phi.right(j, :) = [0.0    1.0];
% end
% %>求解
% for k = 1 : 100
%     eqn.initialize;
%     eqn.setInitialGuess(mm, phi);
%     diffusionOperator(eqn, mm, lambda, phi);
%     sourceOperator(eqn, mm, sp, sc);
% %     eqn.displayOneEquation(400);
%     eqn.solveMatrix(50);
%     eqn.updateField(mm, phi);
% end
% phi.plotField(mm)
% gradE = StaggeredField(mm);
% phi.computeGradient(mm, gradE)
% gradE.plotField(mm)
%% pn结电势场求解
% e = 1.602176634e-19;
% m = 9.10956e-31;
% kb = 1.380649e-23;
% hbar = 1.05457266e-34;
% epsilon0 = 8.854187817e-12;
% epsilonL = 11.9;
% T = 300;
% 
% d0 = 50e-9;
% L0 = 5e-9;
% Nd = 1e15 * 1e6;
% deltaE = 0.056 * e;
% deltaV =0.5;
% V1 = -0.3;
% Vd = 0.7;
% mstar= 0.2;
% Ec = @(x) -deltaV / (5*L0) * (x - d0) + deltaV;
% EF = 0.4 * e;
% 
% phi = ColocateField(mm);
% V = ColocateField(mm);
% lambda = StaggeredField(mm, hbar^2/(2*mstar*m), hbar^2/(2*mstar*m));
% lambda2 = StaggeredField(mm, 1, 1);
% sp = ColocateField(mm);
% sc = ColocateField(mm);
% eqn = LinearSystem(NX, NY);
% 
% %>边界条件
% for i = 2 : mm.NX + 1
%     phi.top(i, :) = [1.0    0.0];
%     phi.bottom(i, :) = [1.0    0.0];
% end
% for j = 2 : mm.NY + 1
%     phi.left(j, :) = [0.0    0.0];
%     phi.right(j, :) = [0.0    1.0];
% end
% for i = 2 : mm.NX + 1
%     V.top(i, :) = [1.0    0.0];
%     V.bottom(i, :) = [1.0    0.0];
% end
% for j = 2 : mm.NY + 1
%     V.left(j, :) = [0.0    0.0];
%     V.right(j, :) = [0.0    1.0];
% end
% 
% %>求解
% for k = 1 : 100
%     %>有效质量方程求解
%     eqn.initialize;
%     eqn.setInitialGuess(mm, phi);
%     %>源项
%     sp.initializeDataValue(mm, 0);
%     sc.initializeDataValue(mm, 0);
%     for i = 2/5*mm.NX : 3/5*mm.NX
%         sp.data(i + 1, mm.NY+1) = -1*e;
%     end
%     diffusionOperator(eqn, mm, lambda, phi);
%     sourceOperator(eqn, mm, sp, sc);
% %     eqn.displayOneEquation(15);
%     eqn.solveMatrix(50);
%     eqn.updateField(mm, phi);
%     
%     %>泊松方程求解
%     eqn.initialize;
%     eqn.setInitialGuess(mm, V);
%     %>源项
%     sp.initializeDataValue(mm, 0);
%     sc.initializeDataValue(mm, 0);
%     for i = 1 : mm.NX
%         g = m*kb*T/(2*pi^2*hbar^2)*log(1 + exp((EF - Ec))/(kb*T));
%         NdPlus = Nd - Nd / (1+exp((deltaE)/(kb*T))/2);
%         sc.data(i + 1, mm.NY+1) = -4*pi/(epsilon0*epsilonL)*e*(g*real(phi.data(i+1)^2) - NdPlus);
%     end
%     diffusionOperator(eqn, mm, lambda2, V);
%     sourceOperator(eqn, mm, sp, sc);
%     eqn.solveMatrix(50);
%     eqn.updateField(mm, V);
%     
% end
% phi.plotField(mm)
% V.plotField(mm)

















