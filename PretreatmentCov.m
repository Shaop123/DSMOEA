function NPop=PretreatmentCov(Population,Problem)
% The eigenmatrix of the population covariance matrix is used for preprocessing operations
N=size(Population,2);
Mathing=randperm(N);
RPopulation1=Population(Mathing(1:round(end/2)));
Population2=Population(Mathing(round(end/2)+1:end));
[B,m] = UpdateParameter(Problem,RPopulation1);
Popdec=RPopulation1.decs;
PopRdec=(Popdec-m)*B;
RPopulation1=Problem.Evaluation(PopRdec);
NPop=[RPopulation1,Population2];
end