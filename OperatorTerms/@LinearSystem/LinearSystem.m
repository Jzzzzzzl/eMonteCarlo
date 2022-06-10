classdef LinearSystem < handle
    %% 
    properties
        matrixSize
        rowNumber
        rowStartID
        columnID
        matrix
        b
        result
    end
    
    methods
        function obj = LinearSystem(nx, ny)
            %>构造函数
            obj.matrixSize = 5 * nx * ny - 2*nx - 2 * ny;
            obj.rowNumber = nx * ny;
            obj.rowStartID = zeros(obj.rowNumber + 1, 1);
            obj.columnID = zeros(obj.matrixSize, 1);
            obj.matrix = zeros(obj.matrixSize, 1);
            obj.b = zeros(obj.rowNumber, 1);
            obj.result = zeros(obj.rowNumber, 1);
            globalID = 1;
            for i = 1 : nx
                for j = 1 : ny
                    rowID = getGlobalID(nx, ny, i, j);
                    rowStartIDwritten = false;
                    %>West node
                    if i > 1
                        nW = getGlobalID(nx, ny, i-1, j);
                        if ~rowStartIDwritten
                            obj.rowStartID(rowID) = globalID;
                            rowStartIDwritten = true;
                        end
                        obj.columnID(globalID) = nW;
                        globalID = globalID + 1;
                    end
                    %>South node
                    if j > 1
                        nS = getGlobalID(nx, ny, i, j-1);
                        if ~rowStartIDwritten
                            obj.rowStartID(rowID) = globalID;
                            rowStartIDwritten = true;
                        end
                        obj.columnID(globalID) = nS;
                        globalID = globalID + 1;
                    end
                    %>this node
                    nP = rowID;
                    if ~rowStartIDwritten
                        obj.rowStartID(rowID) = globalID;
                        rowStartIDwritten = true;
                    end
                    obj.columnID(globalID) = nP;
                    globalID = globalID + 1;
                    %>North node
                    if j < ny
                        nN = getGlobalID(nx, ny, i, j+1);
                        if ~rowStartIDwritten
                            obj.rowStartID(rowID) = globalID;
                            rowStartIDwritten = true;
                        end
                        obj.columnID(globalID) = nN;
                        globalID = globalID + 1;
                    end
                    %>East node
                    if i < nx
                        nE = getGlobalID(nx, ny, i+1, j);
                        if ~rowStartIDwritten
                            obj.rowStartID(rowID) = globalID;
                            rowStartIDwritten = true;
                        end
                        obj.columnID(globalID) = nE;
                        globalID = globalID + 1;
                    end
                end
            end
            obj.rowStartID(obj.rowNumber + 1) = globalID;
        end
    end
    
    methods
        addToMatrix(obj, rowID, colID, value)
        addToRHS(obj, rowID, value)
        solveMatrix(obj, iterNum)
        [error] = getResidual(obj)
    end
end