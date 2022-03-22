classdef PostProcessing < handle
    
    properties(Constant)
        e = 1.602176634e-19;
    end
    
    properties
        totalTime
        mobility
        driftVelocity
    end
    
    methods
        
        function obj = PostProcessing(sh, cc)
            %构造函数
            obj.averageTotalFlyTime(sh, cc);
            obj.electronDirftVelocity(sh, cc);
        end
        
        function averageTotalFlyTime(obj, sh, cc)
            %计算平均总飞行时间
            time = zeros(cc.superElecs, 1);
            for i = 1 : cc.superElecs
                time(i) = sh.eHistory(i, end).time;
            end
            obj.totalTime = sum(time) / cc.superElecs;
            disp(['总模拟时间： ', num2str(obj.totalTime * 1e12), '  ps']);
        end
        
        function electronDirftVelocity(obj, sh, cc)
            %计算漂移速度
            velocity = zeros(cc.superElecs, 1);
            for i = 1 : cc.superElecs
                for j = 1 : cc.noFly
                    velocity(i) = velocity(i) + sh.eHistory(i, j).perdrift;
                end
            end
            obj.driftVelocity = sum(velocity) / (cc.superElecs * cc.noFly);
            disp(['电子漂移速度为： ', num2str(obj.driftVelocity * 100), '  cm/s']);
        end
        
        function electronMobility(~)
            %计算迁移率
            disp(['电子迁移率为： ', num2str(miu), '  cm^2/(V*s)']);
        end
        
    end
    
    methods(Static)
        
        function electronTrace(sh, cc, num, type)
            %单电子轨迹图
            switch type
                case "k"
                    tempk = zeros(cc.noFly, 3);
                    times = zeros(cc.noFly, 1);
                    for i = 1 : cc.noFly
                        times(i) = sh.eHistory(num, i).time;
                        tempk(i,:) = sh.eHistory(num, i).vector;
                    end
                    figure
                    plot3(tempk(:,1), tempk(:,2), tempk(:,3), '*')
                    xlabel("kx");ylabel("ky");zlabel("kz");
                    legend("k-space")
                case "r"
                    positions = zeros(cc.noFly, 1);
                    times = zeros(cc.noFly, 1);
                    for i = 1 : cc.noFly
                        times(i) = sh.eHistory(num, i).time;
                        positions(i) = sh.eHistory(num, i).position(1);
                    end
                    figure
                    plot(times * 1e12, positions * 1e9, '-')
                    xlabel("ps");ylabel("nm");
                    legend("real-space")
                case "e"
                    positions = zeros(cc.noFly, 1);
                    energys = zeros(cc.noFly, 1);
                    for i = 1 : cc.noFly
                        positions(i) = sh.eHistory(num, i).position(1);
                        energys(i) = sh.eHistory(num, i).energy;
                    end
                    figure
                    plot(positions * 1e9, energys / obj.e, '-')
                    xlabel("nm");ylabel("eV");
                    legend("electron energy")
            end
        end
        
        function [aveVelocity] = dirftVelocityWithTime(sh, mm, cc, t, N)
            %漂移速度随时间变化
            velocity = zeros(cc.superElecs, cc.noFly);
            times = zeros(cc.superElecs, cc.noFly);
            for i = 1 : cc.superElecs
                velocity(i, :) = [sh.eHistory(i, :).perdrift];
                times(i, :) = [sh.eHistory(i, :).time];
            end
            %计算历史平均速度
            mm.timeGrid(0, t*1e-12, N);
            aveVelocity = zeros(mm.Nt, 2);
            for t = 1 : mm.Nt
                sumVelocity = 0;
                num = 0;
                for i = 1 : cc.superElecs
                    index = find(mm.time.face(t) <= times(i, :), 1);
                    if isempty(index)
                        index = cc.noFly;
                    end
                    num = num + 1;
                    sumVelocity = sumVelocity + sum(velocity(i, 1:index)) / index;
                end
                aveVelocity(t, 1) = mm.time.point(t + 1);
                aveVelocity(t, 2) = sumVelocity / num;
            end
            
            figure
        %     slg = semilogy(aveVelocity(:, 1) * 1e12, aveVelocity(:, 2) * 100);
            slg = plot(aveVelocity(:, 1)*1e12, aveVelocity(:, 2)*100);
            slg.LineWidth = 2;
            xlabel("ps");ylabel("cm/s");
            legend("drift velocity")
        end
        
        function [numbers] = scatTypeDistribution(sh, cc)
            %散射种类分布
            numbers = zeros(4, 2);
            for i = 1 : cc.superElecs
                types = [sh.eHistory(i,:).scatype];
                % 电离杂质散射
                index1 = types == 1;
                % 声学波形变势散射
                index2 = types >=2 & types <=3;
                % f型吸收声子谷间散射
                index3 = types >=7 & types <=9;
                % f型发射声子谷间散射
                index4 = types >=13 & types <=15;
                % g型吸收声子谷间散射
                index5 = types >=4 & types <=6;
                % g型发射声子谷间散射
                index6 = types >=10 & types <=12;
                
                numbers(1,1) = numbers(1,1) + sum(double(index1));
                numbers(2,1) = numbers(2,1) + sum(double(index2));
                numbers(3,1) = numbers(3,1) + sum(double(index3));
                numbers(3,2) = numbers(3,2) + sum(double(index4));
                numbers(4,1) = numbers(4,1) + sum(double(index5));
                numbers(4,2) = numbers(4,2) + sum(double(index6));
            end
            numbers = numbers / (cc.superElecs * cc.noFly);
            figure
            bar(numbers,'stacked')
        end
        
        function [enumber] = energyDistribution(sh, mm, cc, N)
            %电子能量分布
            energys = zeros(cc.superElecs, cc.noFly);
            for i = 1 : cc.superElecs
                energys(i, :) = [sh.eHistory(i, :).energy] / obj.e;
            end
            energys = reshape(energys', [], 1);
            mm.energyGrid(0, 0.5, N);
            enumber = zeros(mm.NE, 2);
            for i = 1 : mm.NE
                index = energys >= mm.energy.face(i) & energys < mm.energy.face(i + 1);
                enumber(i, 1) = mm.energy.point(i + 1);
                enumber(i, 2) = sum(double(index));
            end
            figure
            bar(enumber(:,1), enumber(:,2));
            xlabel("electron energy(eV)");
            legend("Electron Energy Distribution");
        end
        
        function averageEnergyWithTime(sh, mm, cc, t, N)
            %求电子平均能量随时间的变化关系图
            energy = zeros(cc.superElecs, cc.noFly);
            times = zeros(cc.superElecs, cc.noFly);
            for i = 1 : cc.superElecs
                energy(i, :) = [sh.eHistory(i, :).energy];
                times(i, :) = [sh.eHistory(i, :).time];
            end
            %计算平均能量
            mm.timeGrid(0, t*1e-12, N);
            aveEnergy = zeros(mm.Nt, 2);
            for t = 1 : mm.Nt
                sumEnergy = 0;
                num = 0;
                for i = 1 : cc.superElecs
                    index = find(mm.time.face(t) <= times(i, :), 1);
                    if isempty(index)
                        continue;
                    end
                    num = num + 1;
                    sumEnergy = sumEnergy + energy(i, index);
                end
                aveEnergy(t, 1) = mm.time.point(t + 1);
                aveEnergy(t, 2) = sumEnergy / (num * obj.e);
            end
            figure
        %     slg = semilogy(aveEnergy(:,1)*1e12,aveEnergy(:,2));
            slg = plot(aveEnergy(:, 1)*1e12, aveEnergy(:, 2));
            slg.LineWidth = 2;
            xlabel("ps");ylabel("eV");
            legend("average elevtron energy")
        end
        
    end
end