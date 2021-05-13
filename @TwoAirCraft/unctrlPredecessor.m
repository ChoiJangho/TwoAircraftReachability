function [data_pre_mode1, data_pre_mode2, data_pre_mode3] = unctrlPredecessor(obj, ...
    grid_mode13, grid_mode2, data_mode1, data_mode2, data_mode3)

Rot2 = [0, -1; 1, 0;];
Rot = [0, -1, 0; 1, 0, 0; 0, 0, 1];


data_pre_mode3 = data_mode3;

data_pre_mode2 = data_mode2;
for i = 1:grid_mode2.N(1)
    for j = 1:grid_mode2.N(2)
        data_pre_mode2(i, j, end) = eval_u(grid_mode13, data_mode3, ...
            (Rot2 * [grid_mode2.vs{1}(i); grid_mode2.vs{2}(j);])');
    end
end

% data_pre_mode2 = min(data_pre_reset, data_mode2);

data_pre_mode1 = data_mode1;
% for i = 1:grid_mode13.N(1)
%     for j = 1:grid_mode13.N(2)
%         data_pre_mode1(i, j) = min(eval_u(grid_mode2, data_pre_mode2, ...
%             (Rot * [grid_mode13.vs{1}(i); grid_mode13.vs{2}(j); 0])'), ...
%             data_mode1(i, j));
%     end
% end

% data_pre_mode1 = min(data_pre_reset, data_mode1);