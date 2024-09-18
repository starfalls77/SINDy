function Xi = sparsifyDynamics(Theta,dXdt,lambda,N)

%% Peform sparse regression
Xi = Theta\dXdt;  % initial guess: Least-squares
[n,m]=size(dXdt);

% lambda is our sparsification knob.
for k=1:N
    smallinds = (abs(Xi)<lambda);   % find small coefficients
    Xi(smallinds)=0;                % and threshold
    for ind = 1:m                   % n is state dimension
        biginds = ~smallinds(:,ind);
        % Regress dynamics onto remaining terms to find sparse Xi
        Xi(biginds,ind) = Theta(:,biginds)\dXdt(:,ind); 
    end
end
