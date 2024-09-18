function Lib_sym = poolDataLIST(Lib,Goal_func,Lib_num,Goal_sym)


n = size(Lib,1);

ind = 1;
% % poly order 0
% yout{ind,1} = ['1'];
%ind = ind+1;

% poly order 1
for i=1:Lib_num
    Lib_sym(ind,1) = Lib(i);
    ind = ind+1;
end
output = Lib_sym;
% newout(1) = {''};

for k=1:size(Goal_func,2)
    newout{1,k} = [Lib{k},'dot'];
end
newout = Goal_sym;
for k=1:size(Goal_func,1)
    newout(k+1,1) = output(k);
    for j=1:size(Goal_func,2)
        newout{k+1,1+j} = Goal_func(k,j);
    end
end
newout

% for k=1:size(Goal_func,2);
%     newout{1,1+k} = [Lib{k},'dot'];
% end
% newout = Gole_sym;
% for k=1:size(Goal_func,1)
%     newout(k+1,1) = output(k);
%     for j=1:size(Goal_func,2)
%         newout{k+1,1+j} = Goal_func(k,j);
%     end
% end
% newout

% if(polyorder>=2)
%     % poly order 2
%     for i=1:nVars
%         for j=i:nVars
%             yout{ind,1} = [yin{i},yin{j}];
%             ind = ind+1;
%         end
%     end
% end
% 
% if(polyorder>=3)
%     % poly order 3
%     for i=1:nVars
%         for j=i:nVars
%             for k=j:nVars
%                 yout{ind,1} = [yin{i},yin{j},yin{k}];
%                 ind = ind+1;
%             end
%         end
%     end
% end
