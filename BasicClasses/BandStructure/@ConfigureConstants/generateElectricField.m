function generateElectricField(obj, dt, N, type, minTemp, maxTemp)
    %>生成阶跃电场索引数组
    deltaTime = dt * 1e-12;
    obj.eFieldInput = zeros(N, 2);
    obj.eFieldInput(:, 1) = linspace(deltaTime, N*deltaTime, N);
    obj.eFieldInput(end, 1) = 1;
    switch type
        case 'lin'
            obj.eFieldInput(:, 2) = -1*linspace(minTemp, maxTemp, N);
        case 'log'
            obj.eFieldInput(:, 2) = -1*logspace(minTemp, maxTemp, N);
    end
end