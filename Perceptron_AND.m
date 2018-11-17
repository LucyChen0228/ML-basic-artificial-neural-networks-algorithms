% Hit any key to define four 2-element input vectors denoted by "p". 
pause

p=[0 0 1 1;0 1 0 1];%前后做与运算

% Hit any key to define four 1-element target vectors denoted by "t". 
pause

t=[0 0 0 1];%TAG DESIRED OUTPUT
%[0 1 1 1 ]

% Hit any key to plot the input and target vectors.
pause

v=[-2 3 -2 3];%确定图表的范围
plotpv(p,t,v);

% Hit any key to create the perceptron and set its initial weights to random 
% numbers in the range [0, 1]. The perceptron's threshold is set to zero.
pause

net=newp([0 1;0 1],1);
w=(rands(2))';
b=[0];
net.IW{1,1}=w;
net.b{1}=b;

plotpv(p,t,v);
linehandle=plotpc(net.IW{1},net.b{1});

% Hit any key to train the perceptron for one pass and plot the classification line. 
% The receptron will be trained until the error is zero.
pause

E=1;
  while (sse(E))
     [net,Y,E]=adapt(net,p,t);
     linehandle=plotpc(net.IW{1},net.b{1},linehandle);
     pause
  end;
   
% Hit any key to see whether the perceptron has learned the AND operation.
pause

p=[1;1]
a=sim(net,p)

% Hit any key to continue.
pause

p=[0;1]
a=sim(net,p)

% Hit any key to continue.
pause

p=[1;0]
a=sim(net,p)

% Hit any key to continue.
pause

p=[0;0]
a=sim(net,p)
   
echo off
disp('end of Perceptron_AND')