function save_results(ensemble_test)

mkdir('results/depth_map')
pred = ensemble_test.depth_427_561_refined;

for index_channel = 1 : size(pred,3)
    pred_one = uint16(pred(:,:,index_channel) / 10 * (2^16-1));
    imwrite(pred_one, ['results/depth_map/depth_test', num2str(index_channel, '%03.0f'), '.png'])
end