
% Hit any key to define four 2-element input vectors denoted by "p". 
pause 

p=[0 0 1 1;0 1 0 1]

% Hit any key to define four 1-element target vectors denoted by "t". 
pause 

t=[0 1 1 0]%相于运算后得出的结果

% Hit any key to plot the input and target vectors.
v=[-2 3 -2 3];

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
% The training will be stoped after 10 passes.
pause

for a=1:10;
   [net,Y,E]=adapt(net,p,t);
   linehandle=plotpc(net.IW{1},net.b{1},linehandle);
   pause
end;

% Hit any key to see that the perceptron has not learned the XOR operation.
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
disp('end of Perceptron_XOR')