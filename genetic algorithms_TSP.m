function genetic algorithms_TSP

disp('=============================================================================')
disp('Problem: In the Travelling Salesman Problem (TSP), a salesman has to visit   ')
disp('         every city in a given territory once and then return to his starting')
disp('         point.  The goal is to find the best route such that the travelling ')
disp('         distance is minimised.                                              ')
disp('=============================================================================')

disp('Hit any key to define the number of cities to be visited by a salesman.')
pause

num=20;    % Number of cities to be visited by a salesman

disp(' ')
fprintf(1,'num=%.0f;       Number of cities to be visited by a salesman\n',num);
disp(' ')

rand('seed',1.4929e+009);
city_location=(rand(num,2));

disp('Hit any key to plot locations of the cities on the map.')
pause

figure
plot(city_location(:,1),city_location(:,2),'.r','markersize',25)
hold on

for i=1:num;
   text(city_location(i,1)+0.02,city_location(i,2),sprintf('%g',i));
end

disp('Hit any key to plot all available roads between the cities.')
pause

for n=1:num
   for i=1:num
      plot([city_location(n,1) city_location(i,1)],[city_location(n,2) city_location(i,2)])
   end
end

disp('Hit any key to find distances between the cities.')
pause

city_distance = dist(city_location')

disp('Hit any key to define the size of a chromosome population, the crossover ') 
disp('probability, the mutation probability, and the number of generations.') 
pause 

nind=100;    % Size of a chromosome population
ngenes=num;  % Number of genes in a chromosome
Pc=0.7;      % Crossover probability
Pm=0.01;     % Mutation probability
ngener=60;   % Number of generations
n_show=10;   % Number of generations between showing the progress

disp(' ')
fprintf(1,' nind=%.0f;    Size of the chromosome population\n',nind);
fprintf(1,' Pc=%.1f;      Crossover probability\n',Pc);
fprintf(1,' Pm=%.3f;    Mutation probability\n',Pm);
fprintf(1,' ngener=%.0f;   Number of generations\n',ngener);
fprintf(1,' n_show=%.0f;   Number of generations between showing the progress\n',n_show);
disp(' ')

fprintf(1,'Hit any key to generate a population of %.0f chromosomes.\n',nind);
pause

chrom=[];

for k=1:nind
   num=ngenes; city_array=1:num; xxx=[];
   for n=1:num
      a=rand(1);
      for i=1:num
         if a<i/num
            xxx=[xxx city_array(i)];
            break
         end
      end
      city_array(i)=[]; 
      num=num-1;
   end
   chrom(k,:)=xxx;
end
chrom
rout=[chrom chrom(:,1)];

% Calculate the chromosome fitness
ObjV=evalObjFun(rout,city_distance,nind,ngenes);
best=min(ObjV);
ave=mean(ObjV);

disp('Hit any key to display the best rout found in the initial chromosome population.')
pause

[a b]=min(ObjV);
figure('name','The best rout found in the initial population');
plot(city_location(:,1),city_location(:,2),'.r','markersize',25)
title(['The total distance: ',num2str(a)]);
hold on

for i=1:ngenes;
   text(city_location(i,1)+0.02,city_location(i,2),sprintf('%g',i));
   plot([city_location(rout(b,i),1) city_location(rout(b,(i+1)),1)],[city_location(rout(b,i),2) city_location(rout(b,(i+1)),2)])
end
hold

disp(' ')
disp('Hit any key to run the genetic algorithm.')
pause

for m=1:(ngener/n_show)
   for i=1:n_show
   
      % Fitness evaluation
      fitness=(1./ObjV)';
   
      % Roulette wheel selection
      numsel=round(nind*0.9); % The number of chromosomes to be selected for reproduction
      cumfit=repmat(cumsum(fitness),1,numsel);
      chance=repmat(rand(1,numsel),nind,1)*cumfit(nind,1);
      [selind,j]=find(chance < cumfit & chance >= [zeros(1,numsel);cumfit(1:nind-1,:)]);
      newchrom=chrom(selind,:);
   
      % Crossover 
      points=round(rand(floor(numsel/2),1).*(ngenes-1))+1;
      points=[points round(rand(floor(numsel/2),1).*(ngenes-1))+1];
      points=sort((points*(rand(1)<Pc)),2);
      for j=1:length(points(:,1))   
         swap_sect=newchrom(2*j-1:2*j,points(j,1)+1:points(j,2));
         remain_sect=newchrom(2*j-1:2*j,:);
         for k=1:ngenes
            for n=1:length(swap_sect(1,:))
               if newchrom(2*j-1,k)==swap_sect(2,n);
                  remain_sect(1,k)=0;
               end
               if newchrom(2*j,k)==swap_sect(1,n);
                  remain_sect(2,k)=0;
               end
            end
         end
         [a b c1]=find(remain_sect(1,:)); 
         [a b c2]=find(remain_sect(2,:)); 
         remain_sect=[c1; c2];
         newchrom(2*j-1:2*j,:)=[remain_sect(1:2,1:points(j,1)),...
               flipud(newchrom(2*j-1:2*j,points(j,1)+1:points(j,2))),...
               remain_sect(1:2,points(j,1)+1:length(remain_sect(1,:)))];   
      end

      % Mutation
      for i=1:numsel
         if rand(1)<Pm
            points=sort((round(rand(floor(numsel/2),1).*(ngenes-1))+1)');
            newchrom(i,:)=[newchrom(i,1:points(1)),...
               fliplr(newchrom(i,points(1)+1:points(2))),...
               newchrom(i,points(2)+1:ngenes)];   
         end
      end

      % Creating a new population of chromosomes
      if nind-numsel, % Preserving a part of the parent chromosome population
         [ans,Index]=sort(fitness);
         chrom=[chrom(Index(numsel+1:nind),:);newchrom];
      else % Replacing the entire parent chromosome population with a new one
         chrom=newchrom;
      end

      % Fitness calculation
      rout=[chrom chrom(:,1)];
      ObjV=evalObjFun(rout,city_distance,nind,ngenes);
   
      best=[best min(ObjV)];
      ave=[ave mean(ObjV)];
      end

   [a b]=min(ObjV);

   % Plotting the best rout found in the current population
   figure('name','The best rout found in the current population');
   plot(city_location(:,1),city_location(:,2),'.r','markersize',25)
   title(['Generation # ',num2str(m*n_show),'  The total distance: ',num2str(a)]);
   hold on

   for i=1:ngenes;
      text(city_location(i,1)+0.02,city_location(i,2),sprintf('%g',i));
      plot([city_location(rout(b,i),1) city_location(rout(b,(i+1)),1)],[city_location(rout(b,i),2) city_location(rout(b,(i+1)),2)])
   end
   pause(0.2); 
   hold
end

disp(' ')
disp('Hit any key to display the performance graph.')
pause

figure('name','Performance graph');
plot(0:ngener,best,0:ngener,ave);
legend('Best','Average',0);
title(['Pc = ',num2str(Pc),', Pm = ',num2str(Pm)]);
xlabel('Generations');
ylabel('Distance')


function ObjV=evalObjFun(rout,city_distance,nind,ngenes)
path=0; ObjV=[];
for k=1:nind
   for i=1:ngenes
      path=path+city_distance(rout(k,i),rout(k,(i+1)));
   end
   ObjV(k)=path; path=0;
end



