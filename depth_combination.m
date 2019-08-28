function [ensemble_train, ensemble_test, weight] = depth_combination(data_train, data_test, data_train_rel, data_test_rel, gt_train, gt_test)
addpath('functionset');

%% weight setting
% problem setting
problem000.H = [];
problem000.f = [];
problem000.Aineq = 1.000 * [...
    1,0,0,0,0, ...
    0,0,0,0,0,   0,0,0,0,0,   0,0,0,0,0,   0,0,0,0,0, ...
    0,0,0,0,0,   0,0,0,0,0,   0,0,0,0,0,   0,0,0,0,0, ...
    0,0];
problem000.bineq = 1.0500 * [1];
[temp_Aineq, temp_bineq] = ineq_maker_Ab( sum(problem000.Aineq), 1.0500);
problem000.Aineq(2:size(temp_Aineq,1)+1, (problem000.Aineq(1,:)==1)) = temp_Aineq;
problem000.bineq(2:size(temp_bineq,1)+1, 1) = temp_bineq;
problem000.Aeq = [];
problem000.beq = [];
problem000.lb = [...
    0,0,0,0,0, ...
    0,0,0,0,0,   0,0,0,0,0,   0,0,0,0,0,   0,0,0,0,0, ...
    0,0,0,0,0,   0,0,0,0,0,   0,0,0,0,0,   0,0,0,0,0, ...
    0,0];
problem000.solver = 'quadprog';
problem000.options = optimoptions('fmincon');

problem001.H = [];
problem001.f = [];
problem001.Aineq = 1.000 * [...
    1,0,0,0,0, ...
    0,0,0,0,0,   0,0,0,0,0,   0,0,0,0,0,   0,0,0,0,0, ...
    0,0,0,0,0,   0,0,0,0,0,   0,0,0,0,0,   0,0,0,0,0, ...
    0,0];
problem001.bineq = 1.0500 * [1];
[temp_Aineq, temp_bineq] = ineq_maker_Ab( sum(problem001.Aineq), 1.0500);
problem001.Aineq(2:size(temp_Aineq,1)+1, (problem001.Aineq(1,:)==1)) = temp_Aineq;
problem001.bineq(2:size(temp_bineq,1)+1, 1) = temp_bineq;
problem001.Aeq = [];
problem001.beq = [];
problem001.lb = [...
    0,0,0,0,0, ...
    0,0,0,0,0,   0,0,0,0,0,   0,0,0,0,0,   0,0,0,0,0, ...
    0,0,0,0,0,   0,0,0,0,0,   0,0,0,0,0,   0,0,0,0,0, ...
    0,0];
problem001.solver = 'quadprog';
problem001.options = optimoptions('fmincon');
    
problem002.H = [];
problem002.f = [];
problem002.Aineq = 1.000 * [...
    1,0,0,0,0, ...
    1,0,0,0,0,   0,0,0,0,0,   0,0,0,0,1,   0,0,0,0,0, ...
    0,0,0,0,0,   0,0,0,0,0,   0,0,0,0,0,   0,0,0,0,0, ...
    0,0];
problem002.bineq = 1.0500 * [1];
[temp_Aineq, temp_bineq] = ineq_maker_Ab( sum(problem002.Aineq), 1.0500);
problem002.Aineq(2:size(temp_Aineq,1)+1, (problem002.Aineq(1,:)==1)) = temp_Aineq;
problem002.bineq(2:size(temp_bineq,1)+1, 1) = temp_bineq;
problem002.Aeq = [];
problem002.beq = [];
problem002.lb = [...
    0,0,0,0,0, ...
    0,0,0,0,0,   0,0,0,0,0,   0,0,0,0,0,   0,0,0,0,0, ...
    0,0,0,0,0,   0,0,0,0,0,   0,0,0,0,0,   0,0,0,0,0, ...
    0,0];
problem002.solver = 'quadprog';
problem002.options = optimoptions('fmincon');
    
problem004.H = [];
problem004.f = [];
problem004.Aineq = 1.000 * [...
    1,0,0,0,0, ...
    1,0,0,0,0,   0,0,0,0,0,   0,0,0,0,1,   0,0,0,0,0, ...
    0,0,1,0,0,   0,0,0,0,0,   0,0,0,0,0,   0,0,0,0,0, ...
    0,0];
problem004.bineq = 1.0500 * [1];
[temp_Aineq, temp_bineq] = ineq_maker_Ab( sum(problem004.Aineq), 1.0500);
problem004.Aineq(2:size(temp_Aineq,1)+1, (problem004.Aineq(1,:)==1)) = temp_Aineq;
problem004.bineq(2:size(temp_bineq,1)+1, 1) = temp_bineq;
problem004.Aeq = [];
problem004.beq = [];
problem004.lb = [...
    0,0,0,0,0, ...
    0,0,0,0,0,   0,0,0,0,0,   0,0,0,0,0,   0,0,0,0,0, ...
    0,0,0,0,0,   0,0,0,0,0,   0,0,0,0,0,   0,0,0,0,0, ...
    0,0];
problem004.solver = 'quadprog';
problem004.options = optimoptions('fmincon');
    
problem008.H = [];
problem008.f = [];
problem008.Aineq = 1.000 * [...
    1,0,0,0,0, ...
    1,0,0,0,0,   0,0,0,0,0,   0,0,0,0,1,   0,0,0,0,0, ...
    0,0,1,0,0,   0,0,0,0,0,   1,0,0,0,0,   0,0,0,0,0, ...
    0,0];
problem008.bineq = 1.0500 * [1];
[temp_Aineq, temp_bineq] = ineq_maker_Ab( sum(problem008.Aineq), 1.0500);
problem008.Aineq(2:size(temp_Aineq,1)+1, (problem008.Aineq(1,:)==1)) = temp_Aineq;
problem008.bineq(2:size(temp_bineq,1)+1, 1) = temp_bineq;
problem008.Aeq = [];
problem008.beq = [];
problem008.lb = [...
    0,0,0,0,0, ...
    0,0,0,0,0,   0,0,0,0,0,   0,0,0,0,0,   0,0,0,0,0, ...
    0,0,0,0,0,   0,0,0,0,0,   0,0,0,0,0,   0,0,0,0,0, ...
    0,0];
problem008.solver = 'quadprog';
problem008.options = optimoptions('fmincon');
    
problem016.H = [];
problem016.f = [];
problem016.Aineq = 1.000 * [...
    0,0,0,0,0, ...
    0,0,0,0,0,   0,0,0,0,0,   0,0,0,0,1,   0,0,0,0,0, ...
    0,0,1,0,0,   0,0,0,0,0,   1,0,0,0,0,   0,0,0,0,0, ...
    0,0];
problem016.bineq = 999.999 * [1];
[temp_Aineq, temp_bineq] = ineq_maker_Ab( sum(problem016.Aineq), 11000);
problem016.Aineq(2:size(temp_Aineq,1)+1, (problem016.Aineq(1,:)==1)) = temp_Aineq;
problem016.bineq(2:size(temp_bineq,1)+1, 1) = temp_bineq;
problem016.Aeq = [];
problem016.beq = [];
problem016.lb = [...
    0,0,0,0,0, ...
    0,0,0,0,0,   0,0,0,0,0,   0,0,0,0,0,   0,0,0,0,0, ...
    0,0,0,0,0,   0,0,0,0,0,   0,0,0,0,0,   0,0,0,0,0, ...
    0,0];
problem016.solver = 'quadprog';
problem016.options = optimoptions('fmincon');
    
problem032.H = [];
problem032.f = [];
problem032.Aineq = 1.000 * [...
    0,0,0,0,0, ...
    0,0,0,0,0,   0,0,0,0,0,   0,0,0,0,0,   0,0,0,0,0, ...
    0,0,1,0,0,   0,0,0,0,0,   1,0,0,0,0,   0,0,0,0,0, ...
    0,0];
problem032.bineq = 999.999 * [1];
[temp_Aineq, temp_bineq] = ineq_maker_Ab( sum(problem032.Aineq), 11000);
problem032.Aineq(2:size(temp_Aineq,1)+1, (problem032.Aineq(1,:)==1)) = temp_Aineq;
problem032.bineq(2:size(temp_bineq,1)+1, 1) = temp_bineq;
problem032.Aeq = [];
problem032.beq = [];
problem032.lb = [...
    0,0,0,0,0, ...
    0,0,0,0,0,   0,0,0,0,0,   0,0,0,0,0,   0,0,0,0,0, ...
    0,0,0,0,0,   0,0,0,0,0,   0,0,0,0,0,   0,0,0,0,0, ...
    0,0];
problem032.solver = 'quadprog';
problem032.options = optimoptions('fmincon');
    
problem064.H = [];
problem064.f = [];
problem064.Aineq = 1.000 * [...
    0,0,0,0,0, ...
    0,0,0,0,0,   0,0,0,0,0,   0,0,0,0,0,   0,0,0,0,0, ...
    0,0,0,0,0,   0,0,0,0,0,   1,0,0,0,0,   0,0,0,0,0, ...
    0,0];
problem064.bineq = 999.999 * [1];
[temp_Aineq, temp_bineq] = ineq_maker_Ab( sum(problem064.Aineq), 11000);
problem064.Aineq(2:size(temp_Aineq,1)+1, (problem064.Aineq(1,:)==1)) = temp_Aineq;
problem064.bineq(2:size(temp_bineq,1)+1, 1) = temp_bineq;
problem064.Aeq = [];
problem064.beq = [];
problem064.lb = [...
    0,0,0,0,0, ...
    0,0,0,0,0,   0,0,0,0,0,   0,0,0,0,0,   0,0,0,0,0, ...
    0,0,0,0,0,   0,0,0,0,0,   0,0,0,0,0,   0,0,0,0,0, ...
    0,0];
problem064.solver = 'quadprog';
problem064.options = optimoptions('fmincon');
    
problem128.H = [];
problem128.f = [];
problem128.Aineq = 1.000 * [...
    0,0,0,0,0, ...
    0,0,0,0,0,   0,0,0,0,0,   0,0,0,0,0,   0,0,0,0,0, ...
    0,0,0,0,0,   0,0,0,0,0,   0,0,0,0,0,   0,0,0,0,0, ...
    0,0];
problem128.bineq = 999.999 * [1];
[temp_Aineq, temp_bineq] = ineq_maker_Ab( sum(problem128.Aineq), 11000);
problem128.Aineq(2:size(temp_Aineq,1)+1, (problem128.Aineq(1,:)==1)) = temp_Aineq;
problem128.bineq(2:size(temp_bineq,1)+1, 1) = temp_bineq;
problem128.Aeq = [];
problem128.beq = [];
problem128.lb = [...
    0,0,0,0,0, ...
    0,0,0,0,0,   0,0,0,0,0,   0,0,0,0,0,   0,0,0,0,0, ...
    0,0,0,0,0,   0,0,0,0,0,   0,0,0,0,0,   0,0,0,0,0, ...
    0,0];
problem128.solver = 'quadprog';
problem128.options = optimoptions('fmincon');

% weight.depth_mean
input_data(:,1) = zeros(size(reshape(data_train(5).depth_mean, [], 1)));
for index = find(problem000.Aineq(1,:) == 1)
    if index <= 5
        input_data(:, index) = log(reshape(data_train(index).depth_mean, [], 1));
    else 
        input_data(:, index) = log(reshape(data_train_rel(index-5).depth_mean, [], 1));
    end
end
output_data = log(reshape(gt_train.depth_mean, [], 1));
input_data(:,47) = 0;

problem000.H = input_data' * input_data;
problem000.f = - output_data' * input_data;
weight.depth_mean = quadprog(problem000);
clear index; clear input_data; clear output_data;

% weight.depth_001_001_res
input_data(:,1) = zeros(size(reshape(data_train(5).depth_001_001_res, [], 1)));
for index = find(problem001.Aineq(1,:) == 1)
    if index <= 5
        input_data(:, index) = log(reshape(data_train(index).depth_001_001_res, [], 1));
    else 
        input_data(:, index) = log(reshape(data_train_rel(index-5).depth_001_001_res, [], 1));
    end
end
output_data = log(reshape(gt_train.depth_001_001_res, [], 1));
input_data(:,47) = 0;

problem001.H = input_data' * input_data;
problem001.f = - output_data' * input_data;
weight.depth_001_001_res = quadprog(problem001);
clear index; clear input_data; clear output_data;

% weight.depth_002_002_res
input_data(:,1) = zeros(size(reshape(data_train(5).depth_002_002_res, [], 1)));
for index = find(problem002.Aineq(1,:) == 1)
    if index <= 5
        input_data(:, index) = log(reshape(data_train(index).depth_002_002_res, [], 1));
    else 
        input_data(:, index) = log(reshape(data_train_rel(index-5).depth_002_002_res, [], 1));
    end
end
output_data = log(reshape(gt_train.depth_002_002_res, [], 1));
input_data(:,47) = 0;

problem002.H = input_data' * input_data;
problem002.f = - output_data' * input_data;
weight.depth_002_002_res = quadprog(problem002);
clear index; clear input_data; clear output_data;

% weight.depth_004_004_res
input_data(:,1) = zeros(size(reshape(data_train(5).depth_004_004_res, [], 1)));
for index = find(problem004.Aineq(1,:) == 1)
    if index <= 5
        input_data(:, index) = log(reshape(data_train(index).depth_004_004_res, [], 1));
    else 
        input_data(:, index) = log(reshape(data_train_rel(index-5).depth_004_004_res, [], 1));
    end
end
output_data = log(reshape(gt_train.depth_004_004_res, [], 1));
input_data(:,47) = 0;

problem004.H = input_data' * input_data;
problem004.f = - output_data' * input_data;
weight.depth_004_004_res = quadprog(problem004);
clear index; clear input_data; clear output_data;

% weight.depth_008_008_res
input_data(:,1) = zeros(size(reshape(data_train(5).depth_008_008_res, [], 1)));
for index = find(problem008.Aineq(1,:) == 1)
    if index <= 5
        input_data(:, index) = log(reshape(data_train(index).depth_008_008_res, [], 1));
    else 
        input_data(:, index) = log(reshape(data_train_rel(index-5).depth_008_008_res, [], 1));
    end
end
output_data = log(reshape(gt_train.depth_008_008_res, [], 1));
input_data(:,47) = 0;

problem008.H = input_data' * input_data;
problem008.f = - output_data' * input_data;
weight.depth_008_008_res = quadprog(problem008);
clear index; clear input_data; clear output_data;

% weight.depth_016_016_res
input_data(:,1) = zeros(size(reshape(data_train(5).depth_016_016_res, [], 1)));
for index = find(problem016.Aineq(1,:) == 1)
    if index <= 5
        input_data(:, index) = log(reshape(data_train(index).depth_016_016_res, [], 1));
    else 
        input_data(:, index) = log(reshape(data_train_rel(index-5).depth_016_016_res, [], 1));
    end
end
output_data = log(reshape(gt_train.depth_016_016_res, [], 1));
input_data(:,47) = 0;

problem016.H = input_data' * input_data;
problem016.f = - output_data' * input_data;
weight.depth_016_016_res = quadprog(problem016);
clear index; clear input_data; clear output_data;

% weight.depth_032_032_res
input_data(:,1) = zeros(size(reshape(data_train(5).depth_032_032_res, [], 1)));
for index = find(problem032.Aineq(1,:) == 1)
    if index <= 5
        input_data(:, index) = log(reshape(data_train(index).depth_032_032_res, [], 1));
    else 
        input_data(:, index) = log(reshape(data_train_rel(index-5).depth_032_032_res, [], 1));
    end
end
output_data = log(reshape(gt_train.depth_032_032_res, [], 1));
input_data(:,47) = 0;

problem032.H = input_data' * input_data;
problem032.f = - output_data' * input_data;
weight.depth_032_032_res = quadprog(problem032);
clear index; clear input_data; clear output_data;

% weight.depth_064_064_res
input_data(:,1) = zeros(size(reshape(data_train(5).depth_064_064_res, [], 1)));
for index = find(problem064.Aineq(1,:) == 1)
    if index <= 5
        input_data(:, index) = log(reshape(data_train(index).depth_064_064_res, [], 1));
    else 
        input_data(:, index) = log(reshape(data_train_rel(index-5).depth_064_064_res, [], 1));
    end
end
output_data = log(reshape(gt_train.depth_064_064_res, [], 1));
input_data(:,47) = 0;

problem064.H = input_data' * input_data;
problem064.f = - output_data' * input_data;
weight.depth_064_064_res = quadprog(problem064);
clear index; clear input_data; clear output_data;

% weight.depth_128_128_res
input_data(:,1) = zeros(size(reshape(data_train(5).depth_128_128_res, [], 1)));
for index = find(problem128.Aineq(1,:) == 1)
    if index <= 5
        input_data(:, index) = log(reshape(data_train(index).depth_128_128_res, [], 1));
    else 
        input_data(:, index) = log(reshape(data_train_rel(index-5).depth_128_128_res, [], 1));
    end
end
output_data = log(reshape(gt_train.depth_128_128_res, [], 1));
input_data(:,47) = 0;

problem128.H = input_data' * input_data;
problem128.f = - output_data' * input_data;
weight.depth_128_128_res = quadprog(problem128);
clear index; clear input_data; clear output_data;

%% train data
% Each independent component
ensemble_train.depth_mean = zeros(size(data_train(5).depth_mean));
for index = find(problem000.Aineq(1,:) == 1)
    if index <= 5
        ensemble_train.depth_mean ...
            = ensemble_train.depth_mean ...
            + weight.depth_mean(index) * log(data_train(index).depth_mean);
    else
        ensemble_train.depth_mean ...
            = ensemble_train.depth_mean ...
            + weight.depth_mean(index) * log(data_train_rel(index-5).depth_mean);
    end
end
ensemble_train.depth_mean = exp(ensemble_train.depth_mean);

ensemble_train.depth_001_001_res = zeros(size(data_train(5).depth_001_001_res));
for index = find(problem001.Aineq(1,:) == 1)
    if index <= 5
        ensemble_train.depth_001_001_res ...
            = ensemble_train.depth_001_001_res ...
            + weight.depth_001_001_res(index) * log(data_train(index).depth_001_001_res);
    else
        ensemble_train.depth_001_001_res ...
            = ensemble_train.depth_001_001_res ...
            + weight.depth_001_001_res(index) * log(data_train_rel(index-5).depth_001_001_res);
    end
end
ensemble_train.depth_001_001_res = exp(ensemble_train.depth_001_001_res);

ensemble_train.depth_002_002_res = zeros(size(data_train(5).depth_002_002_res));
for index = find(problem002.Aineq(1,:) == 1)
    if index <= 5
        ensemble_train.depth_002_002_res ...
            = ensemble_train.depth_002_002_res ...
            + weight.depth_002_002_res(index) * log(data_train(index).depth_002_002_res);
    else
        ensemble_train.depth_002_002_res ...
            = ensemble_train.depth_002_002_res ...
            + weight.depth_002_002_res(index) * log(data_train_rel(index-5).depth_002_002_res);
    end
end
ensemble_train.depth_002_002_res = exp(ensemble_train.depth_002_002_res);

ensemble_train.depth_004_004_res = zeros(size(data_train(5).depth_004_004_res));
 for index = find(problem004.Aineq(1,:) == 1)
    
    if index <= 5
        ensemble_train.depth_004_004_res ...
            = ensemble_train.depth_004_004_res ...
            + weight.depth_004_004_res(index) * log(data_train(index).depth_004_004_res);
    else
        ensemble_train.depth_004_004_res ...
            = ensemble_train.depth_004_004_res ...
            + weight.depth_004_004_res(index) * log(data_train_rel(index-5).depth_004_004_res);
    end
end
ensemble_train.depth_004_004_res = exp(ensemble_train.depth_004_004_res);

ensemble_train.depth_008_008_res = zeros(size(data_train(5).depth_008_008_res));
for index = find(problem008.Aineq(1,:) == 1)
    if index <= 5
        ensemble_train.depth_008_008_res ...
            = ensemble_train.depth_008_008_res ...
            + weight.depth_008_008_res(index) * log(data_train(index).depth_008_008_res);
    else
        ensemble_train.depth_008_008_res ...
            = ensemble_train.depth_008_008_res ...
            + weight.depth_008_008_res(index) * log(data_train_rel(index-5).depth_008_008_res);
    end
end
ensemble_train.depth_008_008_res = exp(ensemble_train.depth_008_008_res);

ensemble_train.depth_016_016_res = zeros(size(data_train(5).depth_016_016_res));
for index = find(problem016.Aineq(1,:) == 1)
    if index <= 5
        ensemble_train.depth_016_016_res ...
            = ensemble_train.depth_016_016_res ...
            + weight.depth_016_016_res(index) * log(data_train(index).depth_016_016_res);
    else
        ensemble_train.depth_016_016_res ...
            = ensemble_train.depth_016_016_res ...
            + weight.depth_016_016_res(index) * log(data_train_rel(index-5).depth_016_016_res);
    end
end
ensemble_train.depth_016_016_res = exp(ensemble_train.depth_016_016_res);

ensemble_train.depth_032_032_res = zeros(size(data_train(5).depth_032_032_res));
for index = find(problem032.Aineq(1,:) == 1)
    if index <= 5
        ensemble_train.depth_032_032_res ...
            = ensemble_train.depth_032_032_res ...
            + weight.depth_032_032_res(index) * log(data_train(index).depth_032_032_res);
    else
        ensemble_train.depth_032_032_res ...
            = ensemble_train.depth_032_032_res ...
            + weight.depth_032_032_res(index) * log(data_train_rel(index-5).depth_032_032_res);
    end
end
ensemble_train.depth_032_032_res = exp(ensemble_train.depth_032_032_res);

ensemble_train.depth_064_064_res = zeros(size(data_train(5).depth_064_064_res));
for index = find(problem064.Aineq(1,:) == 1)
    if index <= 5
        ensemble_train.depth_064_064_res ...
            = ensemble_train.depth_064_064_res ...
            + weight.depth_064_064_res(index) * log(data_train(index).depth_064_064_res);
    else
        ensemble_train.depth_064_064_res ...
            = ensemble_train.depth_064_064_res ...
            + weight.depth_064_064_res(index) * log(data_train_rel(index-5).depth_064_064_res);
    end
end
ensemble_train.depth_064_064_res = exp(ensemble_train.depth_064_064_res);

ensemble_train.depth_128_128_res = zeros(size(data_train(5).depth_128_128_res));
for index = find(problem128.Aineq(1,:) == 1)
    if index <= 5
        ensemble_train.depth_128_128_res ...
            = ensemble_train.depth_128_128_res ...
            + weight.depth_128_128_res(index) * log(data_train(index).depth_128_128_res);
    else
        ensemble_train.depth_128_128_res ...
            = ensemble_train.depth_128_128_res ...
            + weight.depth_128_128_res(index) * log(data_train_rel(index-5).depth_128_128_res);
    end
end
ensemble_train.depth_128_128_res = exp(ensemble_train.depth_128_128_res);

ensemble_train.depth_256_256_res = 0; % 먼저 변수 이름만 정의
ensemble_train.depth_427_561_res = 0; % 먼저 변수 이름만 정의

% Depth map by resolution
ensemble_train.depth_001_001 ...
    = ensemble_train.depth_mean ...
    .* ensemble_train.depth_001_001_res;
ensemble_train.depth_002_002 ...
    = imresize(ensemble_train.depth_001_001, [002,002], 'box') ...
    .* ensemble_train.depth_002_002_res;
ensemble_train.depth_004_004 ...
    = imresize(ensemble_train.depth_002_002, [004,004], 'box') ...
    .* ensemble_train.depth_004_004_res;
ensemble_train.depth_008_008 ...
    = imresize(ensemble_train.depth_004_004, [008,008], 'box') ...
    .* ensemble_train.depth_008_008_res;
ensemble_train.depth_016_016 ...
    = imresize(ensemble_train.depth_008_008, [016,016], 'box') ...
    .* ensemble_train.depth_016_016_res;
ensemble_train.depth_032_032 ...
    = imresize(ensemble_train.depth_016_016, [032,032], 'box') ...
    .* ensemble_train.depth_032_032_res;
ensemble_train.depth_064_064 ...
    = imresize(ensemble_train.depth_032_032, [064,064], 'box') ...
    .* ensemble_train.depth_064_064_res;
ensemble_train.depth_128_128 ...
    = imresize(ensemble_train.depth_064_064, [128,128], 'box') ...
    .* ensemble_train.depth_128_128_res;
ensemble_train.depth_256_256 ...
    = exp(imresize(log(ensemble_train.depth_128_128), [256,256], 'bilinear'));
ensemble_train.depth_427_561 ...
    = exp(imresize(log(ensemble_train.depth_256_256), [427,561], 'bilinear'));
ensemble_train.depth_256_256_res ...
    = exp(imresize(log(ensemble_train.depth_128_128), [256,256], 'bilinear')) ...
    ./ exp(imresize(log(ensemble_train.depth_128_128), [256,256], 'box'));
ensemble_train.depth_427_561_res ...
    = exp(imresize(imresize(log(ensemble_train.depth_128_128), [256,256], 'bilinear'), [427,561], 'bilinear')) ...
    ./ exp(imresize(imresize(log(ensemble_train.depth_128_128), [256,256], 'bilinear'), [427,561], 'box'));

%% test data
% Each independent component
ensemble_test.depth_mean = zeros(size(data_test(5).depth_mean));
for index = find(problem000.Aineq(1,:) == 1)
    if index <= 5
        ensemble_test.depth_mean ...
            = ensemble_test.depth_mean ...
            + weight.depth_mean(index) * log(data_test(index).depth_mean);
    else
        ensemble_test.depth_mean ...
            = ensemble_test.depth_mean ...
            + weight.depth_mean(index) * log(data_test_rel(index-5).depth_mean);
    end
end
ensemble_test.depth_mean = exp(ensemble_test.depth_mean);

ensemble_test.depth_001_001_res = zeros(size(data_test(5).depth_001_001_res));
for index = find(problem001.Aineq(1,:) == 1)
    if index <= 5
        ensemble_test.depth_001_001_res ...
            = ensemble_test.depth_001_001_res ...
            + weight.depth_001_001_res(index) * log(data_test(index).depth_001_001_res);
    else
        ensemble_test.depth_001_001_res ...
            = ensemble_test.depth_001_001_res ...
            + weight.depth_001_001_res(index) * log(data_test_rel(index-5).depth_001_001_res);
    end
end
ensemble_test.depth_001_001_res = exp(ensemble_test.depth_001_001_res);

ensemble_test.depth_002_002_res = zeros(size(data_test(5).depth_002_002_res));
for index = find(problem002.Aineq(1,:) == 1)
    if index <= 5
        ensemble_test.depth_002_002_res ...
            = ensemble_test.depth_002_002_res ...
            + weight.depth_002_002_res(index) * log(data_test(index).depth_002_002_res);
    else
        ensemble_test.depth_002_002_res ...
            = ensemble_test.depth_002_002_res ...
            + weight.depth_002_002_res(index) * log(data_test_rel(index-5).depth_002_002_res);
    end
end
ensemble_test.depth_002_002_res = exp(ensemble_test.depth_002_002_res);

ensemble_test.depth_004_004_res = zeros(size(data_test(5).depth_004_004_res));
for index = find(problem004.Aineq(1,:) == 1)
    if index <= 5
        ensemble_test.depth_004_004_res ...
            = ensemble_test.depth_004_004_res ...
            + weight.depth_004_004_res(index) * log(data_test(index).depth_004_004_res);
    else
        ensemble_test.depth_004_004_res ...
            = ensemble_test.depth_004_004_res ...
            + weight.depth_004_004_res(index) * log(data_test_rel(index-5).depth_004_004_res);
    end
end
ensemble_test.depth_004_004_res = exp(ensemble_test.depth_004_004_res);

ensemble_test.depth_008_008_res = zeros(size(data_test(5).depth_008_008_res));
for index = find(problem008.Aineq(1,:) == 1)
    if index <= 5
        ensemble_test.depth_008_008_res ...
            = ensemble_test.depth_008_008_res ...
            + weight.depth_008_008_res(index) * log(data_test(index).depth_008_008_res);
    else
        ensemble_test.depth_008_008_res ...
            = ensemble_test.depth_008_008_res ...
            + weight.depth_008_008_res(index) * log(data_test_rel(index-5).depth_008_008_res);
    end
end
ensemble_test.depth_008_008_res = exp(ensemble_test.depth_008_008_res);

ensemble_test.depth_016_016_res = zeros(size(data_test(5).depth_016_016_res));
for index = find(problem016.Aineq(1,:) == 1)
    if index <= 5
        ensemble_test.depth_016_016_res ...
            = ensemble_test.depth_016_016_res ...
            + weight.depth_016_016_res(index) * log(data_test(index).depth_016_016_res);
    else
        ensemble_test.depth_016_016_res ...
            = ensemble_test.depth_016_016_res ...
            + weight.depth_016_016_res(index) * log(data_test_rel(index-5).depth_016_016_res);
    end
end
ensemble_test.depth_016_016_res = exp(ensemble_test.depth_016_016_res);

ensemble_test.depth_032_032_res = zeros(size(data_test(5).depth_032_032_res));
for index = find(problem032.Aineq(1,:) == 1)
    if index <= 5
        ensemble_test.depth_032_032_res ...
            = ensemble_test.depth_032_032_res ...
            + weight.depth_032_032_res(index) * log(data_test(index).depth_032_032_res);
    else
        ensemble_test.depth_032_032_res ...
            = ensemble_test.depth_032_032_res ...
            + weight.depth_032_032_res(index) * log(data_test_rel(index-5).depth_032_032_res);
    end
end
ensemble_test.depth_032_032_res = exp(ensemble_test.depth_032_032_res);

ensemble_test.depth_064_064_res = zeros(size(data_test(5).depth_064_064_res));
for index = find(problem064.Aineq(1,:) == 1)
    if index <= 5
        ensemble_test.depth_064_064_res ...
            = ensemble_test.depth_064_064_res ...
            + weight.depth_064_064_res(index) * log(data_test(index).depth_064_064_res);
    else
        ensemble_test.depth_064_064_res ...
            = ensemble_test.depth_064_064_res ...
            + weight.depth_064_064_res(index) * log(data_test_rel(index-5).depth_064_064_res);
    end
end
ensemble_test.depth_064_064_res = exp(ensemble_test.depth_064_064_res);

ensemble_test.depth_128_128_res = zeros(size(data_test(5).depth_128_128_res));
for index = find(problem128.Aineq(1,:) == 1)
    if index <= 5
        ensemble_test.depth_128_128_res ...
            = ensemble_test.depth_128_128_res ...
            + weight.depth_128_128_res(index) * log(data_test(index).depth_128_128_res);
    else
        ensemble_test.depth_128_128_res ...
            = ensemble_test.depth_128_128_res ...
            + weight.depth_128_128_res(index) * log(data_test_rel(index-5).depth_128_128_res);
    end
end
ensemble_test.depth_128_128_res = exp(ensemble_test.depth_128_128_res);

ensemble_test.depth_256_256_res = 0; % 먼저 변수 이름만 정의
ensemble_test.depth_427_561_res = 0; % 먼저 변수 이름만 정의

% Depth map by resolution
ensemble_test.depth_001_001 ...
    = ensemble_test.depth_mean ...
    .* ensemble_test.depth_001_001_res;
ensemble_test.depth_002_002 ...
    = imresize(ensemble_test.depth_001_001, [002,002], 'box') ...
    .* ensemble_test.depth_002_002_res;
ensemble_test.depth_004_004 ...
    = imresize(ensemble_test.depth_002_002, [004,004], 'box') ...
    .* ensemble_test.depth_004_004_res;
ensemble_test.depth_008_008 ...
    = imresize(ensemble_test.depth_004_004, [008,008], 'box') ...
    .* ensemble_test.depth_008_008_res;
ensemble_test.depth_016_016 ...
    = imresize(ensemble_test.depth_008_008, [016,016], 'box') ...
    .* ensemble_test.depth_016_016_res;
ensemble_test.depth_032_032 ...
    = imresize(ensemble_test.depth_016_016, [032,032], 'box') ...
    .* ensemble_test.depth_032_032_res;
ensemble_test.depth_064_064 ...
    = imresize(ensemble_test.depth_032_032, [064,064], 'box') ...
    .* ensemble_test.depth_064_064_res;
ensemble_test.depth_128_128 ...
    = imresize(ensemble_test.depth_064_064, [128,128], 'box') ...
    .* ensemble_test.depth_128_128_res;
ensemble_test.depth_256_256 ...
    = exp(imresize(log(ensemble_test.depth_128_128), [256,256], 'bilinear'));
ensemble_test.depth_427_561 ...
    = exp(imresize(log(ensemble_test.depth_256_256), [427,561], 'bilinear'));
ensemble_test.depth_256_256_res ...
    = exp(imresize(log(ensemble_test.depth_128_128), [256,256], 'bilinear')) ...
    ./ exp(imresize(log(ensemble_test.depth_128_128), [256,256], 'box'));
ensemble_test.depth_427_561_res ...
    = exp(imresize(imresize(log(ensemble_test.depth_128_128), [256,256], 'bilinear'), [427,561], 'bilinear')) ...
    ./ exp(imresize(imresize(log(ensemble_test.depth_128_128), [256,256], 'bilinear'), [427,561], 'box'));
