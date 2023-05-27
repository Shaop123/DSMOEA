classdef DSMOEA< ALGORITHM
% <multi> <real> <constrained/none>
    methods
        function main(Algorithm,Problem)
            %% Generate random population
            Population = Problem.Initialization();
            [delta,F] = Algorithm.ParameterSet(0.5,0.5);
            [~,FrontNo,CrowdDis] = EnvironmentalSelection(Population,Problem.N);
            [RefV,~]   = UniformPoint(Problem.N,Problem.M);
            %% Optimization
            while Algorithm.NotTerminated(Population)
                if Problem.FE < 0.6*Problem.maxFE
                NPop=PretreatmentCov(Population,Problem);
                GuidingSolution = GeneratedDirection(Problem,NPop,RefV);
                Offspring = SecondReorganization(Problem,NPop,GuidingSolution);
                [Population,FrontNo,CrowdDis] = EnvironmentalSelection([Population,Offspring],Problem.N);
                else 
                MatingPool =TournamentSelection(2,Problem.N,FrontNo,-CrowdDis);
                BestDec=Population(FrontNo==1).decs;
                N=randperm(size(BestDec,1));
                for i = 1 : Problem.N
                    if rand < delta
                        P=MatingPool;
                        OffspringDec=Population(P(i)).decs+F*(Population(P(randi(Problem.N,1))).decs-Population(P(randi(Problem.N,1))).decs);  
                        Offspring=Problem.Evaluation(OffspringDec);
                    else
                        P =randperm(Problem.N);
                        OffspringDec=Population(P(i)).decs+rand*(BestDec(N(1),:)-Population(i).decs)...,
                            +F*(Population(P(1)).decs-Population(P(2)).decs);  
                        Offspring=Problem.Evaluation(OffspringDec); 
                    end
                 [Population,FrontNo,CrowdDis]= EnvironmentalSelection([Population,Offspring],Problem.N);
                end    
                end       
            end
        end
    end
end