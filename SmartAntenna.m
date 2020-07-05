% =============== SMART ANTENNA ===============
% Code for calculating array factor of an intelligent antenna using
% genetic algorithm to select the best phase combination for a
% sign of known incident.
clc
clear all
close all
format compact

% number of linear elements (antennas)
N=7;

% distance between elements (in wavelength)
d=0.5;

% thetha zero direction (if all elements are in phase)
% 90 for broadside and 0 for endfire
% thetha_zero = 90;

% for genetic algorithm the phases of each element will be different and between
% 0 and 90 each
% generate a matrix containing several random individuals

% boot size
individuals = 25;

thetha_zero=zeros(N,individuals);
for indiv = 1:individuals
    for n=1:N
        thetha_zero(n,indiv)=randi([0,180]);
    end
end

% signal amplitude
% An = 1;

% initializing null AF
AF=zeros(individuals,360);

% calculates array factor for each individual
for i=1:individuals
    AF(i,:)=ArrayFactor(d,N,thetha_zero(:,i));
end

% DIRECTION OF INCIDENCE

%FIXED
% DDI = 60;
% thetha_inc = deg2rad (DDI);

% direction of incidence radius (random)
DDI=(randi([0,180]));
thetha_inc=deg2rad(DDI);

% for better viewing leaves the same size as AF
R = max(AF(1));
for i=2:individuals
    R_ = max(AF(i));
    if R_ > R
        R = R_;
    end
end

% converts to complex
complx_inc = R.*exp(1i*thetha_inc);
figure(1)
compass(complx_inc,'g')
hold on

thetha=[1:1:360];
thetha=deg2rad(thetha);

% draws the n elements on top of each other (it gets polluted!)
figure(1)
for i=1:individuals
    polar(thetha,AF(i,:))
    hold on
end
title('First generation individuals')
legend('Incidence radius direction', 'Location', 'southoutside')

% get better individual values
best1=AF(1,DDI);
index1=1;
bestAF1=AF(1,:);

% Selects the best
for i=2:individuals
    if best1<AF(i,DDI)
        best1=AF(i,DDI);
        bestAF1=AF(i,:);
        index1=i;
    end
end

% selects second best
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

% chart containing only the best 2 of the first generation
figure(2)
compass(complx_inc,'g')
hold on
b1 = polar(thetha,bestAF1,'b');
b2 = polar(thetha,bestAF2,'b');
set(b1, 'linewidth',1)
set(b2, 'linewidth',1)

% selects the best traits to inherit
p1=thetha_zero(:,index1)';
p2=thetha_zero(:,index2)';

% Define the crossing rules to generate the next generation population
% Possibilities:
% -create combinations with the characteristics of each
% -Use their media
% -Random between the two values

% Random crossover test
% generates random binary values for inheritance

xover =(randi([0 1],N,individuals))';
% removes repetitions (for large populations it ends up reducing a lot)
xover = unique(xover,'rows')';
% multiplies parents by crossover giving rise to second generation
L=length(xover);
for l=1:L
    child_prt1(:,l)=p1'.*xover(:,l);
    child_prt2(:,l)=p2'.*~xover(:,l);
end
child=child_prt1+child_prt2;

% repeat the whole procedure again (TRANSFORM THE PROCEDURE
% TO OPTIMIZE INTERACTIONS)
individuals = L;
thetha_zero=child;

AF2=zeros(individuals,360);
for i=1:individuals
    AF2(i,:)=ArrayFactor(d,N,thetha_zero(:,i));
end

% get better individual values
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


% selects second best
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

% plot on top of previous best to see improvement
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
% apparently performing more interactions will not show much gain since
% that a large population guarantees enough variety to find one
% good solution to the problem

% gain comparison
figure(4)
interactions=[1 2];
plot(interactions,[best1 best1_2],'b')
hold on;
plot(interactions, [best2 best2_2],'r')
title('Comparison of gain between first and second generation')
legend('First best', 'Second best')

% performing several tests few showed an increase in gain and when
% shows improvement and is not significant -> this justifies the use of few
% interactions

% ====== SYSTEM IMPROVEMENT STUDY ======
DirTx = DDI 
% defines an interference direction
DirInt = (randi([1,180]))

GainTx = bestAF1_2(DDI)
GainInt = bestAF1_2(DirInt)

% ====== FRIIS FORMULA STUDY =========
% distance in meters between Rx and Tx
dist=(1:1:5000);
% Power Transmitted in Watts
Pt=1;
% Gain Receiver (0dBi) Db over isotropic antenna
Gr=1;
% Transmitter Gain above
% Operating wavelength (4G) in Hz
lambda=1/2.5E9;
% Friis formula finds the power received
Pr=Pt*Gr*GainTx*(lambda./(4*pi*dist)).^2;
% figure (5)
% semilogy (dist, Pr)

% title ('Friis formula for the system')
% legend ('Received Power (W) over distance (meters)')

% improvements for the project:
% -consider interference and try to minimize this
% -consider multiple users and try to maximize these
% - perform comparisons with omnidirectional antennas
% -study of this application in mobile communications
% -of other applications
