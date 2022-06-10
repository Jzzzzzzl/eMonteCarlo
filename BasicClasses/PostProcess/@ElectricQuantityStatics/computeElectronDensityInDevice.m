function computeElectronDensityInDevice(obj, cc)
    %>
    tGrid = linspace(0, 20, 5);
    denEles = zeros(cc.NX, cc.NY);
    for t = 1 : length(tGrid)
        for i = 1 : cc.superElecs
            indext = find(obj.times(i, :) > tGrid(t), 1);
            xPosition = obj.positions(:, 1, i, indext);
            index = find(cc.modelx.face > xPosition, 1) - 1;
            denEles(index) = denEles(index) + 1;
        end
    end
    plot(denEles)
end