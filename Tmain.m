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

 OT = (OT - mean(OT))./ std(OT);
 IT = (IT - mean(IT))./ std(IT);
 OH = (OH - mean(OH))./ std(OH);
 IH = (IH - mean(IH))./ std(IH);
 W = (W - mean(W))./ std(W);
 S = (S - mean(S))./ std(S);



[k,~]=size(OT);
for j= 1:k
    Hi(j,1)=j;
    j=j+1;
end
% 计算数据关于时间的一阶导数
dX = diff(IT)./diff(Hi);
dX(end+1,:) = 0;  %diff函数导致缺一组数据不知道该怎么补全



Var     = [OT IT OH IH W S];
Poly_Var= [IT];

%Step 3: Set goal and symbolic
X = [IT];
g = {'Table','IT'};

%Set differencial section
%Drive     = zeros(size(I));%意义
%dX        = [Drive Drive];

%Step 4：求关于时间的导数，可以摘出去做个文件副本
% 定义起始时间和结束时间
%start_date = datetime(2024, 3, 21, 16, 30, 0);  % 起始时间为2023年9月1日 00:00:00
%end_date = datetime(2024, 3, 22, 14, 55, 0);  % 结束时间为2023年9月30日 23:00:00

% 生成时间序列的日期向量
%time_series = start_date:minutes(5):end_date;

% 将日期向量转换为小时的数值形式
%time_in_hours = hours(time_series - start_date);
%t_vetor = time_in_hours';



%%%%%%%%%%%%需要X关于时间的导数

%%%%%%%%%% Algorithom parameter configuretion%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
Goal_Accuracy = 20; % max: 100 exmple 90,T=1,100 P = 1,95
poly_order     = 4;  % max: 4
Trig_Order     = 1;  % max: 2
Exp_func       = 0;  % max: 1
iter= 1;

%% follows are identificaion code%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
n         = size(Var,2); %Var数组的列数，代表测量的数据的维度
[Goal_D,Goal_S] = GuessLef(X,dX,Var,iter,Trig_Order);
%Step 4: Guess right side expression
[Gues_D,Gues_S] = GuessLib(Poly_Var,dX,iter,Var,poly_order,Trig_Order,Exp_func);
[Libdata,Lib]   = ExcludeGuess(Gues_D,Gues_S,Goal_S);
fprintf('Dynamic library have been established,there are %d terms\n',length(Lib))

%Step 5: Parametric configuration for machine learning
lam_Lib     =[500;400;300;200;100;50;40;30;20;10;9;8;7;6;5;4.5;4;3.5;3;2.5;2;1.5;1;9e-1;8e-1;7e-1;6e-1;...
    5e-1;4e-1;3e-1;2e-1;1e-1;9e-2;8e-2;7e-2;6e-2;5e-2;4e-2;3e-2;2e-2;1e-2;9e-3;8e-3;7e-3;...
    6e-3;5e-3;4e-3;3e-3;2e-3;1e-3;5e-4;1e-4];    %定义了一个列向量，用于lambda的取值，作用未知
[dtat_length,n_state]=size(X);
m          =size(X,2);
M          = length(Lib);

%Step 6: System identification
fprintf('\v Start calculating the best model that could represent the training data...\n \n')
Accuracy = cell(1,length(lam_Lib));
for j = 1:length(lam_Lib)
fprintf('\t Trainning and searching, %d %% finished. \n',round((j/length(lam_Lib))*100))
    lambda_test = lam_Lib(j);
    Xi = sparsifyDynamics(Libdata,X,lambda_test,m);       %Xi是稀疏系数
    Xii  = print_curve(Libdata,Xi);                       %Xii不知道是啥，不知道干啥用的
    Accuracy{1,j} = Testscore(Xii,X,Goal_Accuracy);       %困惑+1
    
end
disp('Finish the training and searching.');%disp函数会直接将内容输出在Matlab命令窗口中
Score = cell2mat(Accuracy);%cell2mat函数为转换元组数组为原始给定类型的数组，即将cell数组Accuracy转换为矩阵

%Step 7: Sparse equations
if max(Score)>Goal_Accuracy
    fprintf('\n Successfully get the model of goal accuracy \n');
    [row,lam_Lib_Idx] = find(Score>=Goal_Accuracy);  %find函数比较复杂，见网页，此处应该是输出Score矩阵中大于等于95的数值的行号和列号
    Lambda_sparse = lam_Lib(min(lam_Lib_Idx)); %min函数，min（A），若A为向量，则返回最小值，若A为矩阵，则返回矩阵每一列的最小值，此处lam_Lib_Idx应为向量，返回最小值
    Xs = sparsifyDynamics(Libdata,X,Lambda_sparse,m);
    Xss= print_curve(Libdata,Xs);
    fprintf('\n\n\n\t the sparset %d expression is:\n',1)
    PrintODE(Lib,Xs,4);                      %Lib与Xs相乘？做什么
    Goal_Score = Getscore(Xss,X);            %不知道用做什么%%%%%%
    fprintf('Acuuracy of ODEs = %2.2f%%',Goal_Score)
    As = poolDataLIST(Lib,Xs,M,g);
    figure(1)
    Showfigure(X,Xss)
else
    
%Step 8: Accuracte equations
    fprintf('\n\n\n\v the limit accuracy for current library\n')
    [Score,Bestlam] = max(Score);
    lambda_best = lam_Lib(Bestlam);
    Xi = sparsifyDynamics(Libdata,X,lambda_best,m);
    Xii= print_curve(Libdata,Xi);
    fprintf('\n\n\n\t The possible dynamic expressions are:\n')
    PrintODE(Lib,Xi,4);
    IdentiScore = Getscore(Xii,X);
    fprintf('Acuuracy of ODEs = %2.2f%%',IdentiScore)
    Ai = poolDataLIST(Lib,Xi,M,g);
    figure(2)
    Showfigure(X,Xii)
end
toc
    fprintf('\n \n Finished\n')
    
%计算平均绝对百分比误差
% 
% C=Xss-IT;
% FC=C./IT;
% FCZ=abs(FC);
%     
% MAPE = sum(FCZ(:))/k;
% 
% 计算平均绝对误差
% CZ=abs(C);
% MAE = sum(CZ(:))/k;


