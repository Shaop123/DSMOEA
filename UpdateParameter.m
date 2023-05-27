function [B,m,ps,Population] = UpdateParameter(Problem,Population)
% Update the covariance matrix and mean of each generation population
    PopDec = Population.decs;
    Flag   = Population.adds(zeros(length(Population),1));
    Ori    = sum(Flag == 1);
    Eig    = sum(Flag == 2);
    ps     = 1/(1+exp(-Problem.M*sqrt(Problem.D)*((Ori+1)/(Eig+Ori+2)-0.5)*Problem.FE/Problem.maxFE));
    C        = cov(PopDec);
    [B,E]    = eig(C);
    E        = diag(E);
    E        = sqrt(E);
    [~,Rank] = sort(E,'descend');
    B        = B(:,Rank);
    m        = mean(PopDec);
end