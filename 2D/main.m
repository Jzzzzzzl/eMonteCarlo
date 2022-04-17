%% 二维模型主程序
clc,clear
close all

rmpath(genpath('/home/jiang/eMonteCarlo')); clc
addpath(genpath('./2D/'))
addpath(genpath('./BasicClasses'))
addpath(genpath('./OperatorTerms'))
addpath(genpath('./functions'))
addpath(genpath('./Material_Si'))
addpath(genpath('./ParallelCompute'))
addpath(genpath('./PostProcess'))

mm = ModelMeshing;
mm.modelXGrid(0, 600e-9, 50);
mm.modelYGrid(0, 500e-9, 50);

cc = ConfigureConstants(mm);
% cc.dopDensity.plotField(mm);
% cc.eleConc.plotField(mm);
% cc.xField.plotField(mm);
% cc.yField.plotField(mm);
% cc.xyField.plotField(mm);








