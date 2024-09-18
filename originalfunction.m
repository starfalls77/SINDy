
syms OT Ti W IT

%d_y=(1.726.*OT.*cos(Ti).*cos(Ti)-17.86.*W.*cos(W).*cos(W)+19.99.*W.*cos(W)+9.212.*W.*sin(W)+1.726.*OT.*sin(Ti).*sin(Ti)-17.56.*W.*sin(W).*sin(W))./(1+7.64.*IT-34.97.*W-31.47.*cos(W)+14.51.*sin(W))

d_y=(1.099*OT - 5.843*W + 1.082*IT*W + 9.169*W*cos(W) - 1.334*OT*sin(W))/(1 + 0.6478*W) 


y=int(d_y,Ti)

disp(['原函数表达式为: ', char(y)]);