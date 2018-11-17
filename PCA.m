

% =============================================
% Problem: Apply PCA to a pilot-plant data set.
% =============================================
%
% Hit any key to load the pilot-plant data.
pause

[data] = PCA_data;

xo=data(:,1); yo=data(:,2);

% Hit any key to subtract the mean of the data dimension from each data value
% in this dimension and plot the normalised pilot-plant data.
pause

x=xo-mean(xo); y=yo-mean(yo);
plot(x,y,'bo','markersize',5);
axis('equal'); axis([-100 80 -80 80]);
title('A plot of the normalised pilot-plant data');
xlabel('Acid number (normalised)');
ylabel('Organic acid content (normalised)');
hold on

% Hit any key to calculate the covariance matrix.
pause

C=cov(x,y)

% Hit any key to calculate eigenvalues and eigenvectors of the covariance matrix.
pause

lambda=eig(C);  % the eigenvalues
lambda=sort(lambda,'descend')
variance=lambda*100/sum(lambda)
[V,D] = eig(C); % V is the matrix with the eigenvectors
V=V(:,2:-1:1)
e1=V(:,1)
e2=V(:,2)

% Hit any key to plot of the normalised pilot-plant data within the axes formed
% by the eigenvectors e1 and e2.
pause

xx1=-100;
yy1=xx1*V(2,1)/V(1,1);
xx2=80;
yy2=xx2*V(2,1)/V(1,1);
line([xx1 xx2],[yy1 yy2]);
hold on
xx1=-100;
yy1=xx1*V(2,2)/V(1,2);
xx2=80;
yy2=xx2*V(2,2)/V(1,2);
line([xx1 xx2],[yy1 yy2]);
line([-100 100],[0 0],'Color',[.8 .8 .8]);
line([0 0],[-80 80],'Color',[.8 .8 .8]);
text(-95,-20,'e1'); 
text(25,-70,'e2');

% Hit any key to plot of the normalised data projected onto the feature space
% formed by both eigenvectors, e1 and e2
pause

xy=[x y];
fin=xy*V;
figure
plot(fin(:,1),fin(:,2),'bo','markersize',5);
axis('equal'); axis([-80 100 -80 80]);
line([-80 100],[0 0]);
line([0 0],[-80 80]);
title('Normalised data projected on the feature space formed by e1 and e2');
xlabel('Acid number (normalised)');
ylabel('Organic acid content (normalised)');
text(90,8,'e1'); 
text(3,70,'e2');

% Hit any key to plot of the normalised data projected onto the feature space
% formed by a single eigenvector, e1
pause

V1=V(:,1)
fin1=xy*V1; y=0;
figure
plot(fin1,y,'bo','markersize',5); 
axis('equal'); axis([-80 100 -80 80]);
line([-80 100],[0 0]);
title('Normalised data projected on the feature space formed by e1');
xlabel('Acid number (normalised)');
ylabel('Organic acid content (normalised)');
text(90,8,'e1'); 

% Hit any key to plot the reconstructed pilot-plant data derived using both 
% eigenvectors, e1 and e2
pause

figure
data=fin*V';
data(:,1)=data(:,1)+mean(xo); data(:,2)=data(:,2)+mean(yo);
plot(data(:,1),data(:,2),'bo','markersize',5);
axis('equal'); axis([10 180 -40 120]);
title('Reconstructed data derived using eigenvectors e1 and e2');
xlabel('Acid number (normalised)');
ylabel('Organic acid content (normalised)');


% Hit any key to plot the reconstructed pilot-plant data derived using a single
% eigenvector, e1
pause

figure
data1=fin1*V1';
data1(:,1)=data1(:,1)+mean(xo); data1(:,2)=data1(:,2)+mean(yo);
plot(data1(:,1),data1(:,2),'bo','markersize',5);
axis('equal'); axis([10 180 -40 120]);
title('Reconstructed data derived using eigenvector e1');
xlabel('Acid number (normalised)');
ylabel('Organic acid content (normalised)');

echo off
disp('end of PCA')