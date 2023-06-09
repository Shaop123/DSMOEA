function Pop = SecondReorganization(Problem,Pop,GuidingSolution)
    Pop=[Pop,GuidingSolution];
    OffPopX = GA(Pop.decs,Problem);
    OffPopX = unique(OffPopX,'rows');
    OffPop  = Problem.Evaluation(OffPopX);
    Pop  = [Pop,OffPop];

end

function Offspring = GA(MatingPool,Global)
% This function includes the SBX crossover operator and the polynomial
% mutatoion operator.

     MaxOffspring = Global.N;
     [N,D] = size(MatingPool);
     RandList = randperm(N);
     MatingPool = MatingPool(RandList, :);
     if  MaxOffspring < 1 || MaxOffspring > N
         MaxOffspring = N;
     end
     if(mod(N,2) == 1)
         MatingPool = [MatingPool; MatingPool(1,:)];
     end  
     
     ProC = 0.9;
     ProM = 1/D;
     
     DisC = 20;
     DisM = 20;
     Offspring = zeros(N,D);
     %crossover
     for i = 1 : 2 : N
         beta = zeros(1,D);
         miu  = rand(1,D);
         beta(miu<=0.5) = (2*miu(miu<=0.5)).^(1/(DisC+1));
         beta(miu>0.5)  = (2-2*miu(miu>0.5)).^(-1/(DisC+1));
         beta = beta.*(-1).^randi([0,1],1,D);
         beta(rand(1,D)>ProC) = 1;
         Offspring(i,:)   = (MatingPool(i,:)+MatingPool(i+1,:))/2+beta.*(MatingPool(i,:)-MatingPool(i+1,:))/2;
         Offspring(i+1,:) = (MatingPool(i,:)+MatingPool(i+1,:))/2-beta.*(MatingPool(i,:)-MatingPool(i+1,:))/2;
     end
     Offspring = Offspring(1:MaxOffspring,:);
     
     %mutation
     if MaxOffspring == 1
         MaxValue = Global.upper;
         MinValue = Global.lower;
     else
         MaxValue = repmat(Global.upper,MaxOffspring,1);
         MinValue = repmat(Global.lower,MaxOffspring,1);
     end
     k    = rand(MaxOffspring,D);
     miu  = rand(MaxOffspring,D);
     Temp = k<=ProM & miu<0.5;
     Offspring(Temp) = Offspring(Temp)+(MaxValue(Temp)-MinValue(Temp)).*((2.*miu(Temp)+(1-2.*miu(Temp)).*(1-(Offspring(Temp)-MinValue(Temp))./(MaxValue(Temp)-MinValue(Temp))).^(DisM+1)).^(1/(DisM+1))-1);
     Temp = k<=ProM & miu>=0.5;
     Offspring(Temp) = Offspring(Temp)+(MaxValue(Temp)-MinValue(Temp)).*(1-(2.*(1-miu(Temp))+2.*(miu(Temp)-0.5).*(1-(MaxValue(Temp)-Offspring(Temp))./(MaxValue(Temp)-MinValue(Temp))).^(DisM+1)).^(1/(DisM+1)));
     
     Offspring(Offspring>MaxValue) = MaxValue(Offspring>MaxValue);
     Offspring(Offspring<MinValue) = MinValue(Offspring<MinValue);
end