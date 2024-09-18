function Score = Getscore(Xii,Real)

m = size(Xii,2);
n = size(Real,2);

Score = cell(1,m);
for i = 1:m
  Score{1,i} = 100-sum(norm(Xii(:,i)-Real(:,i)));
% Score = sprintf('%2.2f%%',100-sum(norm(Xii(:,i)-Real(:,i))))
end
Score = cell2mat(Score)';
end
% %% Using one step prediction to get the simulation data
% dData_Es=Sindy_ODE_RHS(0,Data_test',u)';
% 
% % Get the score of the result
% Score=sum(norm(dData_test-dData_Es));



