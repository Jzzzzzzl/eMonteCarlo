classdef PostProcessing < handle
    
    properties
        totalTime
        mobility
        dirftvelocity
    end
    
    methods
        
        function AverageTotalFlyTime(obj, sh, cc)
            %计算平均总飞行时间
            
            time = zeros(cc.superElecs, 1);
            for i = 1 : cc.superElecs
                time(i) = sh.eHistory(i, end).time;
            end
            obj.totalTime = sum(time) / cc.superElecs;
            disp(["总模拟时间： ", num2str(obj.totalTime * 1e12), "  ps"]);

        end
        
        function ElectronMobility(~)
            %计算迁移率
            
            disp(["电子迁移率为：", num2str(miu), "  cm^2/(V*s)"]);
            
        end
        
        function ElectronDirftVelocity(obj, sh, cc)
            %计算漂移速度
            
            avevelocity = zeros(cc.superElecs, 3);
            for i = 1 : cc.superElecs
                velocity = zeros(1, 3);
                for j = 1 : cc.noFly
                    velocity = velocity + sh.eHistory(i, j).velocity;
                end
                avevelocity(i, :) = velocity / cc.noFly;
            end
            obj.dirftvelocity = sum(avevelocity(:, 1)) / cc.superElecs;
            disp(["电子漂移速度为：", num2str(obj.dirftvelocity * 100), "  cm/s"]);
            
        end
        
        function DirftVelocityWithTime(~, sh, mm, cc)
            %漂移速度随时间变化
            
            velocity = zeros(cc.superElecs, cc.noFly);
            times = zeros(cc.superElecs, cc.noFly);
            for i = 1 : cc.superElecs
                for j = 1 : cc.noFly
                    velocity(i, j) = sh.eHistory(i, j).velocity(1);
                    times(i, j)  = sh.eHistory(i, j).time;
                end
            end
            %计算历史平均速度
            aveVelocity = zeros(mm.Nt, 2);
            for t = 1 : mm.Nt
                Velocity = 0;
                num = 0;
                for i = 1 : cc.superElecs
                    index = find(mm.time.face(t) <= times(i,:), 1);
                    if isempty(index)
                        index = cc.noFly;
                    end
                    num = num + 1;
                    Velocity = Velocity + sum(velocity(i, 1 : index)) / index;
                end
                aveVelocity(t, 1) = mm.time.point(t + 1);
                aveVelocity(t, 2) = Velocity / num;
            end
            
            figure
        %     slg = semilogy(aveVelocity(:, 1) * 1e12, aveVelocity(:, 2) * 100);
            slg = plot(aveVelocity(:, 1) * 1e12, aveVelocity(:, 2) * 100);
            slg.LineWidth = 2;
            xlabel("ps");ylabel("cm/s");
            legend("drift velocity")
            
        end
        
        function ScatTypeDistribution(~, sh, cc)
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
        
        function EnergyDistribution(~, sh, mm, pc, cc)
            %电子能量分布
            
            energys = zeros(cc.superElecs * cc.noFly, 1);
            for i = 1 : cc.superElecs
                for j = 1 : cc.noFly
                    energys(j + (i - 1) * cc.noFly) = sh.eHistory(i, j).energy / pc.e;
                end
            end
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
        
        function ElectronTrace(~, sh, pc, cc, num, type)
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
                    plot(positions * 1e9, energys / pc.e, '-')
                    xlabel("nm");ylabel("eV");
                    legend("electron energy")
            end

        end
        
        function AverageEnergyWithTime(~, sh, mm, pc, cc)
            %求电子平均能量随时间的变化关系图
            
            energy = zeros(cc.superElecs, cc.noFly);
            times = zeros(cc.superElecs, cc.noFly);
            for i = 1 : cc.superElecs
                for j = 1 : cc.noFly
                    energy(i, j) = sh.eHistory(i, j).energy;
                    times(i, j) = sh.eHistory(i, j).time;
                end
            end
            %计算平均能量
            aveEnergy = zeros(mm.Nt, 2);
            for t = 1 : mm.Nt
                Energy = 0;
                num = 0;
                for i = 1 : cc.superElecs
                    index = find(mm.time.face(t) <= times(i, :), 1);
                    if isempty(index)
                        continue;
                    end
                    num = num + 1;
                    Energy = Energy + energy(i, index);
                end
                aveEnergy(t, 1) = mm.time.point(t + 1);
                aveEnergy(t, 2) = Energy / (num * pc.e);
            end
            figure
        %     slg = semilogy(aveEnergy(:,1)*1e12,aveEnergy(:,2));
            slg = plot(aveEnergy(:, 1) * 1e12, aveEnergy(:, 2));
            slg.LineWidth = 2;
            xlabel("ps");ylabel("eV");
            legend("average elevtron energy")
            
        end
        
    end
    
end