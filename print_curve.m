
function Xii = print_curve (Theta,Xi)

Ti = Xi';
ind = 1;
for i = 1:size(Ti,1);
dx = Theta .* Ti(i,:);
dxx = dx(:,sum(dx)~=0);
Xii(:,ind) = sum(dxx,2);
ind = ind +1;
end
end
