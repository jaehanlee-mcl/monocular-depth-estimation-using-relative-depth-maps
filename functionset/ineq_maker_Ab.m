function [Aineq, bineq] = ineq_maker_Ab(col_num, ratio)

Aineq = zeros( col_num*(col_num-1)/2, col_num );
bineq = zeros( col_num*(col_num-1)/2, 1);

index = 0;
for index1 = 1 : col_num-1
    for index2 = index1+1 : col_num
        
        index = index + 1;
        Aineq(index, index1) = 1;
        Aineq(index, index2) = -ratio;
        bineq(index, 1) = 0;
        
        index = index + 1;
        Aineq(index, index1) = -ratio;
        Aineq(index, index2) = 1;
        bineq(index, 1) = 0;
        
    end
end