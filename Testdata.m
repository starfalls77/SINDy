clear all;
clc;
tic;
%Step 1: Loading datasets
V = xlsread('D:\桌面\20240318会议投稿代码\数据储存\温室数据测量.xlsx');
%Step 2: Set right side basic variables
OT=V(:,1);
IT=V(:,2);
OH=V(:,3);
IH=V(:,4);
W=V(:,5);
S=V(:,6);

OT=movemeanfilter(OT);
IT=movemeanfilter(IT);
OH=movemeanfilter(OH);
IH=movemeanfilter(IH);
W=movemeanfilter(W);
S=movemeanfilter(S);


[k,~]=size(OT);
for j= 1:k
    Ti(j,1)=j;
    j=j+1;
end

d_y=(1.099.*OT - 5.843.*W + 1.082.*IT.*W + 9.169.*W.*cos(W) - 1.334.*OT.*sin(W))./(1 + 0.6478.*W) 

t0=IT(1,1);
y(1,:)=t0;
for i=2:size(d_y,1)
    y(i,:)=t0+d_y(i-1,:);
    i=i+1;
end



plot(y,'r')
hold on;
plot(IT,'b');
hold off;
