clear; clc; close all
try
    Evaluation_Default_Mode;
catch
end

clear; clc; close all
[data_train, data_test, gt_train, gt_test] = data_load();
[data_train, data_test, gt_train, gt_test] = depth_decomposition(data_train, data_test, gt_train, gt_test);
[data_train_rel, data_test_rel] = ALS_restore(data_train, data_test);
[ensemble_train, ensemble_test, weight] = depth_combination(data_train, data_test, data_train_rel, data_test_rel, gt_train, gt_test);
ensemble_test = depth_refine(ensemble_test, gt_test);
metrics = evaluation(ensemble_test, gt_test)
save_results(ensemble_test);