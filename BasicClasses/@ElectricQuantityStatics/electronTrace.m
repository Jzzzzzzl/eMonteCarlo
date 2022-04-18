function electronTrace(obj, sh, cc, num, type)
    %>单电子轨迹图
    switch type
        case "k"
            tempk = zeros(cc.noFly, 3);
            for i = 1 : cc.noFly
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
        case 'xy'
            positions = zeros(cc.noFly, 2);
            for i = 1 : cc.noFly
                positions(i, 1) = sh.eHistory(num, i).position(1);
                positions(i, 2) = sh.eHistory(num, i).position(2);
            end
            figure
            rectangle('Position',[0 0 cc.modelx.face(end)*1e9 cc.modely.face(end)*1e9]);
            hold on;
            plot(positions(:, 1) * 1e9, positions(:, 2) * 1e9, '-')
            xlabel("nm");ylabel("nm");
            legend("real-space")
    end
end