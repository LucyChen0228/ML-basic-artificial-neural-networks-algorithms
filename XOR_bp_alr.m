

rand('seed',5655);

% Hit any key to define four 2-element input vectors denoted by "p". 
pause

p=[1 1 -1 -1;1 -1 1 -1]

% Hit any key to define four 1-element target vectors denoted by "t". 
pause

t=[-1 1 1 -1]

% Hit any key to plot the input and target vectors
pause

%figure(1)
%plotpv(p,t);
%axis([-2 3 -2 3]);
%hold on;

% Hit any key to define the network architecture.
pause

s1=3; %Two neurons in the hidden layer
s2=1; %One neuron in the output layer

% Hit any key to create the network and initialise its weights and biases.
pause

net = newff(p,t,s1,{'tansig','purelin'},'traingda');
net.divideFcn = '';

% Hit any key to set up the frequency of the training progress to be displayed,
% maximum number of epochs, acceptable error, and learning rate. 
pause 

net.trainParam.show=1;      % Number of epochs between showing the progress
net.trainParam.epochs=1000; % Maximum number of epochs
net.trainParam.goal=0.001;  % Performance goal
net.trainParam.lr=0.1;      % Learning rate
net.trainParam.lr_inc=1.05; % Learning rate increase multiplier 可以自己调整 看能不能更快
net.trainParam.lr_dec=0.7;  % Learning rate decrease multiplier

% Hit any key to train the back-propagation network with adaptive learning rate. 
pause 

[net,tr]=train(net,p,t);

% Hit any key to plot the training errors and learning rates. 
pause 

figure(2)
subplot(2,1,1), plot(tr.epoch,tr.perf)
tstring = sprintf('Training for %g epochs',max(tr.epoch));
title(tstring);
xlabel ('Epoch'); ylabel('Sum-squared error');
subplot(2,1,2), plot(tr.epoch,tr.lr)
xlabel ('Epoch'); ylabel('Learning rate');

% Hit any key to plot the classification line.
pause

echo off

x = [-2:0.2:3];
y = [-2:0.2:3];
xy = [];
for i=1:length(x);
    for k = 1:length(y);
        xy(i,k) = sim(net,[x(i); y(k)]);
    end
end
echo on

figure(1)
contour(x, y,xy, [1])
hold on
plotpv(p,t);
axis([-2 3 -2 3]);
hold off

% Hit any key to see whether the network has learned the XOR operation.
pause 

p
t
a=sim(net,p)

echo off
disp('end of XOR_bp_alr')

