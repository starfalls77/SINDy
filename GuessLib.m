function [P_Data,P_sym]=GuessLib(u_Poly,dX,iter,u,Poly_Order,Trig_Order,Exp_Order)
%% First get the size of the X matrix, determin the data length and the number of variables we have.
[Data_Length,Variable_Number]=size(u_Poly);
[~,Variable_Number_dX]=size(dX);
[~,Variable_Number_u]=size(u);



% Also create the symbolic variable
Symbol_u_Poly=sym('P',[Variable_Number,1]);
Symbol_dX=sym('dz',[Variable_Number_dX,1]);
Symbol_u=sym('u',[Variable_Number_u,1]);


%% Now according the Highest Polynomial Order entered, we will calculate the data matrix.
Data=[];
Index=1;

%% First calculate the polynomial term

%Order Zero:
Data(:,Index)=ones(Data_Length,1);
Sym_Struct{1,Index}=sym(1);

%Order One:
if Poly_Order>=1
    for i=1:Variable_Number
        Index=Index+1;
        Data(:,Index)=u_Poly(:,i);
        Sym_Struct{1,Index}=Symbol_u_Poly(i,1);
    end
end

%Order Two:
if Poly_Order>=2
    for i=1:Variable_Number
        for j=1:Variable_Number
            Index=Index+1;
            Data(:,Index)=u_Poly(:,i).*u_Poly(:,j);
            Sym_Struct{1,Index}=Symbol_u_Poly(i,1)*Symbol_u_Poly(j,1);
        end
    end
end

%Order Three:
if Poly_Order>=3
    for i=1:Variable_Number
        for j=1:Variable_Number
            for k=1:Variable_Number
                Index=Index+1;
                Data(:,Index)=u_Poly(:,i).*u_Poly(:,j).*u_Poly(:,k);
                Sym_Struct{1,Index}=Symbol_u_Poly(i,1)*Symbol_u_Poly(j,1)*Symbol_u_Poly(k,1);
            end
        end
    end
end

%Order Four:
if Poly_Order>=4
    for i=1:Variable_Number
        for j=1:Variable_Number
            for k=1:Variable_Number
                for p=1:Variable_Number
                     Index=Index+1;
                     Data(:,Index)=u_Poly(:,i).*u_Poly(:,j).*u_Poly(:,k).*u_Poly(:,p);
                     Sym_Struct{1,Index}=Symbol_u_Poly(i,1)*Symbol_u_Poly(j,1)*Symbol_u_Poly(k,1)*Symbol_u_Poly(p,1);
                end
            end
        end
    end
end

%% Then add the Trigonometric Function in the output data:

%Order One:
if Trig_Order>=1
    for i=1:Variable_Number_u
        Index=Index+1;
        Data(:,Index)=sin(u(:,i));
        Sym_Struct{1,Index}=sin(Symbol_u(i,1));
    end
    for i=1:Variable_Number_u
        Index=Index+1;
        Data(:,Index)=cos(u(:,i));
        Sym_Struct{1,Index}=cos(Symbol_u(i,1));
    end
end

%Order Two:
if Trig_Order>=2
    for i=1:Variable_Number_u
        Index=Index+1;
        Data(:,Index)=sin(u(:,i)).^2;
        Sym_Struct{1,Index}=sin(Symbol_u(i,1))^2;     
    end
    
    for i=1:Variable_Number_u
        Index=Index+1;
        Data(:,Index)=cos(u(:,i)).^2;
        Sym_Struct{1,Index}=cos(Symbol_u(i,1))^2;     
    end
end
%% add the exponential function
%oder one
if Exp_Order>=1
    for i=1:Variable_Number_u
        Index=Index+1;
    Data(:,Index)=exp(u(:,i));
    Sym_Struct{1,Index}=exp(Symbol_u(i,1));
    end
end



pin=Index;
j=0;

%20240319在右侧加入dX与Data的相乘/%%%%%%%%%%%dX与Var的相乘要不要加/%%%0325加入
for k=1:Variable_Number_dX
    for i=1:pin
        j=j+1;
       P_Data(:,j)=dX(:,k).*Data(:,i);
       P_sym{1,j}=Symbol_dX(k,1)*(Sym_Struct{1,i});
    end
end


for k=1:Variable_Number_dX
    for i=1:Variable_Number_u
        j=j+1;
        P_Data(:,j)=dX(:,k).*u(:,i);
        P_sym{1,j}=Symbol_dX(k,1)*Symbol_u(i,1);
    end
end

for i=1:Variable_Number_u
    for k=1:pin
        j=j+1;
        P_Data(:,j)=u(:,i).*Data(:,k);
        P_sym{1,j}=Symbol_u(i,1)*(Sym_Struct{1,k});
    end
end


%%%加入根号元素
% [H,L]=size(P_Data)
% for i=1:L
%     j=j+1
%     P_Data(:,j)=sqrt(P_Data(:,i));
%     P_sym{1,j}= P_sym{1,i}^0.5;
% end

    
    
    
    
%% Frome here, we add the u*Theta elements in our data, but it doesn't work
% if Highest_U_Order>=1
%     for j=1:Variable_Number_u
%         for k=1:pin
%             Index=Index+1;
%             Data(:,Index)=u(:,j).*Data(:,k);
%             Sym_Struct{1,Index}=Symbol_u(j,1)*(Sym_Struct{1,k});
%         end
%     end
% else
%     for j=1:Variable_Number_u
%         Index=Index+1;
%         Data(:,Index)=u(:,j);
%         Sym_Struct{1,Index}=Symbol_u(j,1);
%     end
% end
% %% From here, we add the dX*Theta elements in our data.
% pin1=Index;
% if Highest_dPoly_Order>=1
%     for k=1:pin1
%         Index=Index+1;
%         Data(:,Index)=dX(:,1).*Data(:,k);
%         Sym_Struct{1,Index}=Symbol_dX(iter,1)*(Sym_Struct{1,k});
%     end
% end
