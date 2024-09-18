function ODEs = PrintODE (Sym_Struct,Xi,p)


%% Now output the SINDy Identified ODEs

m = size(Xi,2);%cell2sym,str2sym

for i = 1:m;
   ODEs = vpa(cell2sym(Sym_Struct)*Xi(:,i),p)
end
end



