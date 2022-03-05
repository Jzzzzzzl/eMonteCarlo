%% 

clc,clear
close all
addpath(genpath(pwd))
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
bs = BandStructure("Si");
bs.BandStructurePlot(50, bs, pc);
bs.ElectricVelocityPlot(50, bs, pc);


RotMatrix(pi/2, "x")





