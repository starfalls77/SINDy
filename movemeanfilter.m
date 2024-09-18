function filtered_data = movemeanfilter(data)



% 定义移动平均窗口大小
window_size = 12;

% 进行移动平均滤波
filtered_data = movmean(data, window_size);



end


