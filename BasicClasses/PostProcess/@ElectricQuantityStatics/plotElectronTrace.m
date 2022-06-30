function plotElectronTrace(obj, cc, num, type)
    %>单电子轨迹图
    switch type
        case 'k'
            tempk = zeros(cc.noFly, 3);
            for i = 1 : cc.noFly
                tempk(i, :) = obj.vectors(:, :, num, i);
            end
            figure
            plot3(tempk(:, 1), tempk(:, 2), tempk(:, 3), '*')
            xlabel("kx"); ylabel("ky"); zlabel("kz");
            title("k-space")
        case 'r'
            tempr = zeros(cc.noFly, 3);
            for i = 1 : cc.noFly
                tempr(i, :) = obj.positions(:, :, num, i);
            end
            figure
            plot(obj.times(num, :) * 1e12, tempr(:, 1) * 1e9, '-')
            xlabel("ps"); ylabel("nm");
            title("real-space")
        case 'e'
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
            
        case 'd'
            cc.timeGrid(0, 0.999*obj.minTime, 100);
            p = zeros(1, 3, cc.superElecs, cc.Nt);
            h = figure;
            filename = [cc.filePath 'postDatas/test.gif'];
            for t = 1 : cc.Nt
                for i = 1 : cc.superElecs
                    index = find(obj.times(i, :) >= cc.time.face(t), 1);
                    p(:, :, i, t) = deal(obj.positions(:, :, i, index));
                end
                x = squeeze(p(:, 1, :, t))*1e9;
                y = squeeze(p(:, 2, :, t))*1e9;
                plot(x, y, 'o')
                axis([0 cc.modelx.face(end)*1e9 0 cc.modely.face(end)*1e9])
                drawnow;
                %>输出为gif图片
                frame = getframe(h);
                im = frame2im(frame);
                [imind, cm] = rgb2ind(im, 256);
                if t == 1
                    imwrite(imind, cm, filename, 'gif', 'Loopcount', inf);
                else
                    imwrite(imind, cm, filename, 'gif', 'WriteMode', 'append');
                end
            end
            
    end
end