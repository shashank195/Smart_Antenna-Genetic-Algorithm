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
%thetha_zero = 90;
%thetha_zero1 = 90;
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
%An = 1;

% initializing null AF
AF=zeros(individuals,360);

% calculates array factor for each individual
for i=1:individuals
    AF(i,:)=ArrayFactor(d,N,thetha_zero(:,i));
end

% DIRECTION OF INCIDENCE

%FIXED
DDI1 = 60;
DDI2 = 120;
thetha_inc1 = deg2rad (DDI1);
thetha_inc2 = deg2rad (DDI2);
% direction of incidence radius (random)
%DDI=(randi([0,180]));
%thetha_inc=deg2rad(DDI);

% for better viewing leaves the same size as AF
R1 = max(AF(1));
for i=2:individuals
    R_ = max(AF(i));
    if R_ > R1
        R1 = R_;
    end
end
R2 = max(AF(1));
for i=2:individuals
    R_ = max(AF(i));
    if R_ > R2
        R2 = R_;
    end
end

% converts to complex
complx_inc1 = R1.*exp(1i*thetha_inc1);
complx_inc2 = R2.*exp(1i*thetha_inc2);
figure(1)
compass(complx_inc1,'g')
hold on
compass(complx_inc2,'r')
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
