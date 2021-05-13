function data_pre_in_mode1 = ctrlPredecessor(obj, grid_mode1, grid_mode2, data_in_mode2)
Rot = [0, -1, 0; 1, 0, 0; 0, 0, 1];
data_pre_in_mode1 = zeros(grid_mode1.N');
for i = 1:grid_mode1.N(1)
    for j = 1:grid_mode1.N(2)
        data_pre_in_mode1(i, j) = eval_u(grid_mode2, data_in_mode2, ...
            (Rot * [grid_mode1.vs{1}(i); grid_mode1.vs{2}(j); 0])');
    end
end
