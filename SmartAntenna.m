clc
clear all
close all
format compact

N=7;

d=0.5;

individuals = 25;

thetha_zero=zeros(N,individuals);
for indiv = 1:individuals
    for n=1:N
        thetha_zero(n,indiv)=randi([0,180]);
    end
end

AF=zeros(individuals,360);
for i=1:individuals
    AF(i,:)=ArrayFactor(d,N,thetha_zero(:,i));
end


DDI=(randi([0,180]));
thetha_inc=deg2rad(DDI);

R = max(AF(1));
for i=2:individuals
    R_ = max(AF(i));
    if R_ > R
        R = R_;
    end
end
complx_inc = R.*exp(1i*thetha_inc);
figure(1)
compass(complx_inc,'g')
hold on

thetha=[1:1:360];
thetha=deg2rad(thetha);

figure(1)
for i=1:individuals
    polar(thetha,AF(i,:))
    hold on
end
title('First generation individuals')
legend('Incidence radius direction', 'Location', 'southoutside')

best1=AF(1,DDI);
index1=1;
bestAF1=AF(1,:);
for i=2:individuals
    if best1<AF(i,DDI)
        best1=AF(i,DDI);
        bestAF1=AF(i,:);
        index1=i;
    end
end
best2=AF(1,DDI);
index2=1;
bestAF2=AF(i,:);
for i=2:individuals
    if best2<AF(i,DDI) && i ~= index1
        best2=AF(i,DDI);
        bestAF2=AF(i,:);
        index2=i;
    end
end

figure(2)
compass(complx_inc,'g')
hold on
b1 = polar(thetha,bestAF1,'b');
b2 = polar(thetha,bestAF2,'b');
set(b1, 'linewidth',1)
set(b2, 'linewidth',1)


p1=thetha_zero(:,index1)';
p2=thetha_zero(:,index2)';

xover =(randi([0 1],N,individuals))';
xover = unique(xover,'rows')';
L=length(xover);
for l=1:L
    child_prt1(:,l)=p1'.*xover(:,l);
    child_prt2(:,l)=p2'.*~xover(:,l);
end
child=child_prt1+child_prt2;


individuals = L;
thetha_zero=child;

AF2=zeros(individuals,360);
for i=1:individuals
    AF2(i,:)=ArrayFactor(d,N,thetha_zero(:,i));
end


best1_2=AF2(1,DDI);
index1_2=1;
bestAF1_2=AF2(1,:);

for i=2:individuals
    if best1_2<AF2(i,DDI)
        best1_2=AF2(i,DDI);
        bestAF1_2=AF2(i,:);
        index1_2=i;
    end
end



best2_2=AF2(1,DDI);
index2_2=1;
bestAF2_2=AF2(1,:);
for i=2:individuals
    if best2_2<AF2(i,DDI) && i ~= index1_2 && AF2(i,DDI)~= best1_2
        best2_2=AF2(i,DDI);
        bestAF2_2=AF2(i,:);
        index2_2=i;
    end
end


figure(2)
hold on
b3 = polar(thetha,bestAF1_2, 'r');
hold on
b4 = polar(thetha,bestAF2_2, 'r');
title('Best Solutions')
legend('Incidence radius direction', 'First best', 'Second best', 'First best after crossing', 'Second best after crossing', 'Location', 'southoutside')
set(b3, 'linewidth',2)
set(b4, 'linewidth',2)

figure(3)
compass(complx_inc,'g')
hold on
for i=1:individuals
    polar(thetha,AF2(i,:))
end
title('Second generation individuals')
legend('Incidence radius direction', 'Location', 'southoutside')


figure(4)
interacoes=[1 2];
plot(interacoes,[best1 best1_2],'b')
hold on;
plot(interacoes, [best2 best2_2],'r')
title('Comparison of gain between first and second generation')
legend('First best', 'Second best')


DirTx = DDI 

DirInt = (randi([1,180]))

GainTx = bestAF1_2(DDI)
GainInt = bestAF1_2(DirInt)

dist=(1:1:5000);

Pt=1;

Gr=1;

lambda=1/2.5E9;

Pr=Pt*Gr*GainTx*(lambda./(4*pi*dist)).^2;

