%% 

clc,clear
% Macro;
% Public;
% myfuns = Funs;
% 
% electron = myfuns.GenerateElectron(0,0,0.2*e);
% electron.valley = -3;
% electron.k = [-0.018464   -0.056825    -0.94385]*dGX;
% 
% 
% % energy = myfuns.ComputeElecEnergy(electron);
% % myfuns.ElectronInformation(electron)
% % disp(energy/e)
% % 
% velocity = myfuns.ComputeElecVelocity(electron);
% disp(velocity)
% % disp(myfuns.eBand(electron,1))
% % 
% % myfuns.VerifyProgram(1)
%  
% % energy = 2*e;
% % rx = real(sqrt(2 * energy * mt) / hbar);
% % ry = real(sqrt(2 * energy * mt) / hbar);
% % rz = real(sqrt(2 * energy * ml) / hbar);
% % n = 20;
% % [x1, y1, z1] = ellipsoid(0,0,0,rx,ry,rz,n);
% % xlabel("x");ylabel("y");zlabel("z");
% % surf(x1,y1,z1)
% % axis equal


pc = PhysicConstants("Si");
sc = ScatterringCurve("Si", pc);
ps = PhononStatus;
ps.vector = 1.06e9;
ps.polar = "LA";
ps.GetFrequency(sc)


tic
[x1, y1, z1] = ellipsoid(0,0,0,1,1,1,10);
toc

tic
ellipsoid([b,a],500);
toc
n = 10;
randx = round(rand(1)*(n - 1)) + 1;
randy = round(rand(1)*(n - 1)) + 1;
sqrt(x1(randx,randy)^2 + y1(randx,randy)^2 + z1(randx,randy)^2)

alpha = 0.2;
f1 = @(x) x.^2;
f2 = @(x) x.^2.*(1-log10(abs(x)+1).*x.^0.4);

x = -2:0.01:2;
plot(x,f1(x))
hold on
plot(x,f2(x))






