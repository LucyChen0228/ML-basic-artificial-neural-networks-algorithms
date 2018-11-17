function genetic algorithms_2

disp('=========================================================')
disp('Genetic algorithms: the fitness function of two variables')
disp('=========================================================')

disp('============================================================================')
disp('Reference: Negnevitsky, M., "Artificial Intelligence: A Guide to Intelligent')  
disp('           Systems", 3rd edn. Addison Wesley, Harlow, England, 2011.        ')
disp('           Sec. 7.3 Genetic algorithms                                      ')
disp('============================================================================')

disp('===============================================================================')
disp('Problem: It is desired to find the maximum value of the "peak" function of two ')
disp('         variables (1-x).^2.*exp(-x.^2-(y+1).^2)-(x-x.^3-y.^5).*exp(-x.^2-y.^2)') 
disp('         where parameters "x" and "y" vary between -3 and +3.                  ')
disp('===============================================================================')

disp('Hit any key to define the objective function.') 
pause

ObjFun='(1-x).^2.*exp(-x.^2-(y+1).^2)-(x-x.^3-y.^5).*exp(-x.^2-y.^2)';

disp(' ')
disp('ObjFun=(1-x).^2.*exp(-x.^2-(y+1).^2)-(x-x.^3-y.^5).*exp(-x.^2-y.^2)');
disp(' ')

disp('Hit any key to define the size of a chromosome population, the number of variables, ')
disp('the number of genes in a chromosome, crossover and mutation probabilities, possible ') 
disp('minimum and maximum values of parameters "x" and "y", and the number of generations.')
pause 

nind=6;     % Size of a chromosome population
nvar=2;     % Number of variables
ngenes=16;  % Number of genes in a chromosome: each variable is represented by (ngenes/2) genes
Pc=0.9;     % Crossover probability
Pm=0.005;   % Mutation probability
xymin=-3;   % Possible minimum values of parameters "x" and "y"
xymax=3;    % Possible maximum values of parameters "x" and "y"
ngener=100; % Number of generations

disp(' ')
fprintf(1,'nind=%.0f;      Size of a chromosome population\n',nind);
fprintf(1,'nvar=%.0f;      Number of variables\n',nvar);
fprintf(1,'ngenes=%.0f;   Number of genes in a chromosome: each variable is represented by (ngenes/2) genes\n',ngenes);
fprintf(1,'Pc=%.1f;      Crossover probability\n',Pc);
fprintf(1,'Pm=%.3f;    Mutation probability\n',Pm);
fprintf(1,'xymin=%.0f;    Possible minimum values of parameters "x" and "y"\n',xymin);
fprintf(1,'xymax=%.0f;     Possible maximum values of parameters "x" and "y"\n',xymax);
fprintf(1,'ngener=%.0f;  Number of generations\n',ngener);
disp(' ')

fprintf(1,'Hit any key to generate a population of %.0f chromosomes.\n',nind);
pause

chrom=round(rand(nind,ngenes))

disp('Hit any key to obtain decoded integers from the chromosome strings.')
pause

xy=zeros(nind,nvar);
lvar=ngenes/nvar;
if length(xymin)==1,xymin=xymin*ones(1,nvar);end
if length(xymax)==1,xymax=xymax*ones(1,nvar);end

for ind=1:nvar,
   xy(:,ind)=chrom(:,1+lvar*(ind-1):lvar*ind)*[2.^(lvar-1:-1:0)]';
   xy(:,ind)=xymin(ind)+(xymax(ind)-xymin(ind))*(xy(:,ind)+1)./(2^lvar+1);
end

disp('   =================')
disp('       x         y')
disp('   =================')
disp(xy);
disp('   =================')

% Calculation of the chromosome fitness
ObjV=evalObjFun(ObjFun,xy(:,1),xy(:,2));
best(1)=max(ObjV);
ave(1)=mean(ObjV);

disp('Hit any key to display initial locations of the chromosomes on the surface of the "peak" function.')
pause

figure('name',['Chromosome locations on the surface of the "peak" function']);
[x,y]=meshgrid(xymin(1):.25:xymax(1),xymin(2):.25:xymax(2));
z=evalObjFun(ObjFun,x,y); z=z+4;
mesh(x,y,z)
axis([-3 3 -3 3 0 6])
hold;
contour(x,y,z,20,'k')

scatter3(xy(:,1),xy(:,2),ObjV+4.08,40,'r','filled')
plot(xy(:,1),xy(:,2),'k.','markersize',23)
title(['Hit any key to continue']);
xlabel('Parameter "x"');
ylabel('Parameter "y"');
zlabel('Chromosome fitness');
hold;

disp(' ')
disp('Hit any key to run the genetic algorithm.')
pause

for i=1:ngener,
   % Fitness evaluation
   fitness=ObjV;
   if min(ObjV)<0
      fitness=fitness-min(ObjV);
   end
   
   % Roulette wheel selection
   numsel=round(nind*(1-0.2));  % The number of chromosomes to be selected for reproduction
   cumfit=repmat(cumsum(fitness),1,numsel);
   chance=repmat(rand(1,numsel),nind,1)*cumfit(nind,1);
   [selind,j]=find(chance < cumfit & chance >= [zeros(1,numsel);cumfit(1:nind-1,:)]);
   newchrom=chrom(selind,:);

   % Crossover 
   points=round(rand(floor(numsel/2),1).*(ngenes-2))+1;
   points=points.*(rand(floor(numsel/2),1)<Pc);   
   for j=1:length(points),
      if points(j),
         newchrom(2*j-1:2*j,:)=[newchrom(2*j-1:2*j,1:points(j)),...
               flipud(newchrom(2*j-1:2*j,points(j)+1:ngenes))];
      end
   end
   
   % Mutation
   mut=find(rand(numsel,ngenes)<Pm);
   newchrom(mut)=round(rand(length(mut),1));
   
   % Fitness calculation
   newxy=zeros(numsel,nvar);
	for ind=1:nvar,
   	newxy(:,ind)=newchrom(:,1+lvar*(ind-1):lvar*ind)*[2.^(lvar-1:-1:0)]';
   	newxy(:,ind)=xymin(ind)+(xymax(ind)-xymin(ind))*(newxy(:,ind)+1)./(2^lvar+1);
   end

	newObjV=evalObjFun(ObjFun,newxy(:,1),newxy(:,2));

   % Creating a new population of chromosomes
   if nind-numsel, % Preserving a part of the parent chromosome population
      [ans,Index]=sort(fitness);
      chrom=[chrom(Index(numsel+1:nind),:);newchrom];
      xy=[xy(Index(numsel+1:nind),:);newxy];
      ObjV=[ObjV(Index(numsel+1:nind));newObjV];      
   else % Replacing the entire parent chromosome population with a new one
      chrom=newchrom;
      xy=newxy;
      ObjV=newObjV;
   end
   
   % Plotting current locations of the chromosomes on the surface of the "peak" function
   mesh(x,y,z)
   axis([-3 3 -3 3 0 6])
   hold;
   contour(x,y,z,20,'k')
   hold on;

   scatter3(xy(:,1),xy(:,2),ObjV+4.08,40,'r','filled')
	plot(xy(:,1),xy(:,2),'k.','markersize',23)
   title(['Generation # ',num2str(i)]);
   xlabel('Parameter "x"');
   ylabel('Parameter "y"');
   zlabel('Chromosome fitness');
   pause(0.2)
	hold;

	best(1+i)=max(ObjV);
	ave(1+i)=mean(ObjV);
end

disp(' ')
disp('Hit any key to display the performance graph.')
pause

figure('name','Performance graph');
plot(0:ngener,best,0:ngener,ave);
legend('Best','Average',0);
xlabel('Number of generations');
title(['Pc = ',num2str(Pc),', Pm = ',num2str(Pm)]);
xlabel('Generations');
ylabel('Fitness')

function z=evalObjFun(ObjFun,x,y)
z=eval(ObjFun);

