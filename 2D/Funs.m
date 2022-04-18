%% 函数集文件

function Funs = Funs
    % 预处理部分
    Funs.GroupVelocityDOSTao       = @GroupVelocityDOSTao;
    Funs.MeshGrid                  = @MeshGrid;
    Funs.AllGrid                   = @AllGrid;
    Funs.Karray                    = @Karray;
    Funs.ScatterringTable          = @ScatterringTable;
    Funs.PlotScatterringRate       = @PlotScatterringRate;
    Funs.ChooseScatType            = @ChooseScatType;
    Funs.ReadDopDensity            = @ReadDopDensity;
    Funs.HarmonicAverage           = @HarmonicAverage;
    Funs.PlotDensity               = @PlotDensity;
    Funs.ComputeSuperCharge        = @ComputeSuperCharge;
    Funs.ReadEleconc               = @ReadEleconc;
    Funs.GenerateElectron          = @GenerateElectron;
    Funs.MaxwellVelocity           = @MaxwellVelocity;
    Funs.PlotMaxwell               = @PlotMaxwell;
    Funs.Choosek                   = @Choosek;
    Funs.Random                    = @Random;
    Funs.InitializeInfor           = @InitializeInfor;
    % 计算模拟部分
    Funs.eBand                     = @eBand;
    Funs.Ifbeyondbz                = @Ifbeyondbz;
    Funs.ReadElectricField         = @ReadElectricField;
    Funs.TotalElecField            = @TotalElecField;
    Funs.PlotElectricField         = @PlotElectricField;
    Funs.SearchEfield              = @SearchEfield;
    Funs.ChooseFvalley             = @ChooseFvalley;
    Funs.EscatP                    = @EscatP;
    Funs.TimeForFly                = @TimeForFly;
    Funs.Localization              = @Localization;
    Funs.Directangle               = @Directangle;
    Funs.MESFETBoundary            = @MESFETBoundary;
    Funs.FlyProcess                = @FlyProcess;
    Funs.ParFunction               = @ParFunction;
    Funs.SubsectionParllel         = @SubsectionParllel;
    % 后处理部分
    Funs.TotalFlyTime              = @TotalFlyTime;
    Funs.StatisticPhonon           = @StatisticPhonon;
    Funs.HeatGeneration            = @HeatGeneration;
    Funs.PlotSumnAndnDot           = @PlotSumnAndnDot;
    Funs.FarDistributionFunction   = @FarDistributionFunction;
    Funs.SolveConvection           = @SolveConvection;
    Funs.ComputeTF                 = @ComputeTF;
    Funs.SolveDiffusion            = @SolveDiffusion;
    Funs.ComputeTeff               = @ComputeTeff;
    Funs.PolarTeff                 = @PolarTeff;
    Funs.PlotTeff                  = @PlotTeff;
    Funs.ElectronTrace             = @ElectronTrace;
    Funs.AverageEnergyTime         = @AverageEnergyTime;
    Funs.AverageEnergyDisplace     = @AverageEnergyDisplace;
    Funs.Write2datFile             = @Write2datFile;
    Funs.Write3datFile             = @Write3datFile;
    
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 预处理部分 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  1  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 说明：可使用VASP计算色散关系
% (1)使用的是拟合的二阶色散关系;
% (2)考虑了U散射/边界散射;
% (3)使用spline插值;

% 输出二维dat文件
function [backvalue] = Write2datFile(name,xvalue,yvalue)
    % name:文件名
    % xvalue:横轴变量值
    % yvalue:纵轴变量值
    Macro;
    
    backvalue = zeros(length(xvalue),2);
    fid = fopen(name, 'w+');
    for k = 1:length(xvalue)
        backvalue(k,1) = xvalue(k);
        backvalue(k,2) = yvalue(k);
        fprintf(fid, '%.2f\t', backvalue(k,1));
        fprintf(fid, '%.2f\n', backvalue(k,2));
    end
    fclose(fid);
    
end

%输出3维dat文件
function [backvalue] = Write3datFile(name, grid, value)
%      name------------文件名
%      grid------------网格
%      value-----------二维矩阵

    Macro;
    
    backvalue = zeros(NX*NY,3);
    fid = fopen(name, 'w+');
    for i = 2:NX + 1
       for j = 2:NY + 1
           k = NY*(i-2)+j-1;
           backvalue(k,1) = grid.x.face(i)*1e9;
           backvalue(k,2) = grid.y.face(j)*1e9;
           backvalue(k,3) = value(j, i);
           fprintf(fid, '%.2f\t', backvalue(k,1));
           fprintf(fid, '%.2f\t', backvalue(k,2));
           fprintf(fid, '%.2f\n', backvalue(k,3));
       end
    end
    fclose(fid);

end

























