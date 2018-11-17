
% Hit any key to define two target fundamental memories to be stored 
% in the network as the two columns of the matrix T. 
pause

T=[1 1 1;-1 -1 -1]'

% Hit any key to plot the Hopfield state space with the two fundamental memories 
% identified by red markers. 
pause

plot3(T(1,:),T(2,:),T(3,:),'r.','markersize',20)
axis([-1 1 -1 1 -1 1]); axis manual; hold on;
title('Representation of the possible states for the three-neuron Hopfield network') 
set(gca,'box','on'); view([37.5 30]);

% Hit any key to obtain weights and biases of the Hopfield network. 
pause

net=newhop(T);

% Hit any key to test the network with six unstable states represented as the 
% six-column matrix P. Unstable states are identified by blue markers. 
pause

P=[-1 1 1;1 -1 1;1 1 -1;-1 -1 1;-1 1 -1;1 -1 -1]'

for i=1:6
  a = {P(:,i)};
  [y,Pf,Af]=sim(net,{1 10},{},a);
  record=[cell2mat(a) cell2mat(y)];
  start=cell2mat(a);
  plot3(start(1,1),start(2,1),start(3,1),'b*',record(1,:),record(2,:),record(3,:))
  drawnow;
% Hit any key to continue.
pause
end

% Each of these unstable states represents a single error, compared to the fundamental
% memories. As you have just seen, the fundamental memories attract unstable states.

% Hit any key to test the network with three random input vectors. Random states are 
% identified by green '*' markers. 
pause

for i=1:3
  a={rands(3,1)};
  [y,Pf,Af]=sim(net,{1 10},{},a);
  record=[cell2mat(a) cell2mat(y)];
  start=cell2mat(a);
  plot3(start(1,1),start(2,1),start(3,1),'g*',record(1,:),record(2,:),record(3,:),'g-')
% Hit any key to continue.
pause
end

% The Hopfield network always converge to a stable state. However, this stable state
% does not necessarily represents a fundamental memory.

% Hit any key to see how four input vectors, represented as the four-column matrix P, 
% converge to a stable but undesired state in the center of the state space.   
% The undesired state is identified by the magenta circle.
pause

P=[1 0 -1; 0 1 -1; -1 0 1; 0 -1 1]'

for i=1:4;
  a = {P(:,i)};
  [y,Pf,Af] = sim(net,{1 10},{},a);
  record=[cell2mat(a) cell2mat(y)];  
  start=cell2mat(a);
  plot3(start(1,1),start(2,1),start(3,1),'m*',record(1,:),record(2,:),record(3,:),'m-')
    if i<2
        plot3(0,0,0,'mo')
    end
% Hit any key to continue.
pause
end;

echo off
disp('end of Hopfield.m')