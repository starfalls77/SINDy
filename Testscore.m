function Test_Score = Testscore(Xii,Real,Goal_Accuracy)

m = size(Xii,2);
for i=m;
Test_Score = 100-sum(norm(Xii-Real));
end
fprintf('\t Current model score: %4.2f. Goal score is %d \n',Test_Score,Goal_Accuracy)
while Test_Score>=Goal_Accuracy
    disp('Successfully arrived, seeking the limit of the Library.')
    break
end