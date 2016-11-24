% Abdel-Razzak Merheb
% SIMULINK Quadrotor simulation using Bouabdallah's system
% The controller used here is a PD controller
% Values of gains resembles those used by Mr. Bouabdallah
% 29/11/2012
% % % % % % % % % % % % % % %
clc
clear all
close all
load('IOVectors.mat')
global Jr Ix Iy Iz b d l m g Kpz Kdz Kpp Kdp Kpt Kdt Kpps Kdps ZdF PhidF ThetadF PsidF ztime phitime thetatime psitime Zinit Phiinit Thetainit Psiinit Uone Utwo Uthree Ufour Ez Ep Et Eps

% of the PD controller

kpp = 0.8;
kdp = 0.4;

kpt = 1.2;
kdt = 0.4;

kpps = 1;
kdps = 0.4;

kpz = 100;
kdz = 20;
Gains = [kpp kdp kpt kdt kpps kdps kpz kdz];
disp(Gains);
% Quadrotor constants
Ix = 7.5*10^(-3);  % Quadrotor moment of inertia around X axis
Iy = 7.5*10^(-3);  % Quadrotor moment of inertia around Y axis
Iz = 1.3*10^(-2);  % Quadrotor moment of inertia around Z axis
Jr = 6.5*10^(-5);  % Total rotational moment of inertia around the propeller axis
b = 3.13*10^(-5);  % Thrust factor
d = 7.5*10^(-7);  % Drag factor
l = 0.23;  % Distance to the center of the Quadrotor
m = 0.65;  % Mass of the Quadrotor in Kg
g = 9.81;   % Gravitational acceleration


%%start position calculations
%%BS Airport

deg2rad=pi/180;

a = 6378137; %%semi major
b = 6356752.3142; %semi minor
StartLat  = 52.319557*deg2rad;
StartLong = 10.563042*deg2rad;
StartAlt  = 84;
StartECEFX = (a/(sqrt(cos(StartLat)*cos(StartLat)+(b^2/a^2)*sin(StartLat)*sin(StartLat)))+ StartAlt)*cos(StartLat)*cos(StartLong);
StartECEFY = (a/(sqrt(cos(StartLat)*cos(StartLat)+(b^2/a^2)*sin(StartLat)*sin(StartLat)))+ StartAlt)*cos(StartLat)*sin(StartLong);
StartECEFZ = (b/(sqrt((a^2/b^2)*cos(StartLat)*cos(StartLat)+sin(StartLat)*sin(StartLat)))+ StartAlt)*sin(StartLat);
%compute the local NEX axis (unit vectors in ECEF
NEDEastECEF  =[-sin(StartLong) cos(StartLong) 0];
NEDNorthECEF =[-sin(StartLat) 0 cos(StartLat)];
NEDDownECEF  =[-cos(StartLat)*cos(StartLong) -cos(StartLat)*sin(StartLong) -sin(StartLat)*cos(StartLong)];

% % Controlling the Quadrotor
%% sim('PDQuadrotor')