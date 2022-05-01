function plotElectronTrace(obj, cc, num, type)
    %>单电子轨迹图
    switch type
        case "k"
            tempk = zeros(cc.noFly, 3);
            for i = 1 : cc.noFly
                tempk(i, :) = obj.vectors(:, :, num, i);
            end
            figure
            plot3(tempk(:, 1), tempk(:, 2), tempk(:, 3), '*')
            xlabel("kx"); ylabel("ky"); zlabel("kz");
            title("k-space")
        case "r"
            tempr = zeros(cc.noFly, 3);
            for i = 1 : cc.noFly
                tempr(i, :) = obj.positions(:, :, num, i);
            end
            figure
            plot(obj.times(num, :) * 1e12, tempr(:, 1) * 1e9, '-')
            xlabel("ps"); ylabel("nm");
            title("real-space")
        case "e"
            tempr = zeros(cc.noFly, 3);
            for i = 1 : cc.noFly
                tempr(i, :) = obj.positions(:, :, num, i);
            end
            figure
            plot(tempr(:, 1) * 1e9, obj.energys(num, :) / obj.e, '-')
            xlabel("nm"); ylabel("eV");
            title("electron energy")
        case 'xy'
            tempr = zeros(cc.noFly, 3);
            for i = 1 : cc.noFly
                tempr(i, :) = obj.positions(:, :, num, i);
            end
            figure
            rectangle('Position',[0 0 cc.modelx.face(end)*1e9 cc.modely.face(end)*1e9]);
            hold on
            plot(tempr(:, 1) * 1e9, tempr(:, 2) * 1e9, '-')
            xlabel("nm"); ylabel("nm");
            title("real-space")
            hold off
    end
end