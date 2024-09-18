%% the guess of the left hand side.
function [Data,Sym_Struct]=GuessLef(X,dX,u,iter,Highest_Trig_Order)
%% First get the size of the X matrix, determin the data length and the number of variables we have.
[Data_Length,Variable_Number]=size(X);
[~,Variable_Number_dX]=size(dX);
[~,Variable_Number_u]=size(u);

% Also create the symbolic variable
Symbol=sym('z',[Variable_Number,1]);
Symbol_dX=sym('dz',[Variable_Number,1]);
Symbol_u=sym('u',[Variable_Number_u,1]);


%% Now according the Highest Polynomial Order entered, we will calculate the data matrix.
Data=[];
Index=1;

Data(:,Index)=ones(Data_Length,1);
Sym_Struct{1,Index}=1;

%% First calculate the polynomial term

% Form basis vector
% Basis=[X(:,1) X(:,2) X(:,1)-X(:,2) X(:,1)-2*X(:,2) dX(:,1) dX(:,2)];
% Basis_Sym=[Symbol(1) Symbol(2) Symbol(1)-Symbol(2) Symbol(1)-2*Symbol(2) Symbol_dX(1) Symbol_dX(2)];
% 
% % Add dx term
% for i = 1:size(Basis,2)
% Data(:,Index)=Basis(:,i);
% Sym_Struct{1,Index}=Basis_Sym(1,i);
% Index=Index+1;
% end

% Basis=[X(:,1) X(:,2) X(:,1)-X(:,2) dX(:,1) dX(:,2)];
% Basis_Sym=[Symbol(1) Symbol(2) Symbol(1)-Symbol(2) Symbol_dX(1) Symbol_dX(2)];

for i = 1:Variable_Number
    Data(:,Index)=X(:,i);
    Sym_Struct{1,Index}=Symbol(i,1);
    Index=Index+1;
end

% Data(:,Index)=X(:,1);
% Sym_Struct{1,Index}=Symbol(iter);
% Index=Index+1;

% Add dx term
for j = 1:Variable_Number_dX
    Data(:,Index)=dX(:,j);
    Sym_Struct{1,Index}=Symbol_dX(:,j);
    Index=Index+1;
end

%0325左侧加入dX的平方，规避右侧开根号形式的函数
for j = 1:Variable_Number_dX
    Data(:,Index)=dX(:,j).*dX(:,j);
    Sym_Struct{1,Index}=Symbol_dX(:,j).*Symbol_dX(:,j);
    Index=Index+1;
end


if Highest_Trig_Order >= 1
    for k=1:Variable_Number_u
       Data(:,Index)=dX(:,1).*cos(u(:,Variable_Number_u)).^Highest_Trig_Order;
       Sym_Struct{1,Index}=Symbol_dX(1)*cos(Symbol_u(k,1)).^Highest_Trig_Order;
       Index=Index+1;
    end
    for k=1:Variable_Number_u
      Data(:,Index)=dX(:,1).*sin(u(:,Variable_Number_u)).^Highest_Trig_Order;
      Sym_Struct{1,Index}=Symbol_dX(1)*sin(Symbol_u(k,1)).^Highest_Trig_Order;
      Index=Index+1;
    end
end


