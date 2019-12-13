%% loading Info
clc 
close all;
clear all;
%this program will calculate the resistance information from the annealed IV curves 
path(path,'C:\\Users\\janas\\OneDrive\Documents\5th Year\4U02 - Lab');
load('Annealed_IV.mat')

%% plot all of them 
close all
plot(N12_annealed_IV(:,1),N12_annealed_IV(:,2)); hold on;
plot(N23_annealed_IV(:,1),N23_annealed_IV(:,2));hold on;
plot(N34_annealed_IV(:,1),N34_annealed_IV(:,2)); hold on;
plot(N45_annealed_IV(:,1),N45_annealed_IV(:,2)); hold on;
plot(N56_annealed_IV(:,1),N56_annealed_IV(:,2)); hold on;
legend('d = 1500','d = 750','d = 500','d = 250','d = 100')
xlim([-0.21,0.21]);
ylim([-0.11,0.11]);
%750 and 250 are bad

%% linear regression 
close all

V = N12_annealed_IV(:,1);
I = N12_annealed_IV(:,2);
slope = diff(I)./diff(V);
slope = find(slope~=0);
V = V(slope(1):(slope(end)+1));
I = I(slope(1):(slope(end)+1));
[fit_1500,gof_1500,xd,yd] = LinearFit(V,I);
plot(xd,yd,'rx');hold on; 
plot(fit_1500,'r-','predfunc');hold on;


V = N23_annealed_IV(:,1);
I = N23_annealed_IV(:,2);
slope = diff(I)./diff(V);
slope = find(slope~=0);
V = V(slope(1):(slope(end)+1));
I = I(slope(1):(slope(end)+1));
[fit_750,gof_750,xd,yd] = LinearFit(V,I);
plot(xd,yd,'bx');hold on; 
plot(fit_750,'b-','predfunc');hold on;



V = N34_annealed_IV(:,1);
I = N34_annealed_IV(:,2);
slope = diff(I)./diff(V);
slope = find(slope>0.0001|slope<-0.0001);
V = V(slope(1):(slope(end)+1));
I = I(slope(1):(slope(end)+1));
[fit_500,gof_500,xd,yd] = LinearFit(V,I);
%bounds = predint(fit_500,xd,0.95,'functional','on');plot(xd,bounds,':m'); hold on;
plot(xd,yd,'mx');hold on; 
plot(fit_500,'m-','predfunc');hold on;

V = N45_annealed_IV(:,1);
I = N45_annealed_IV(:,2);
slope = diff(I)./diff(V);
slope = find(slope>0.0001|slope<-0.0001);
V = V(slope(1):(slope(end)+1));
I = I(slope(1):(slope(end)+1));
[fit_250,gof_250,xd,yd] = LinearFit(V,I);
plot(xd,yd,'cx');hold on; 
plot(fit_250,'c-','predfunc');hold on;


V = N56_annealed_IV(:,1);
I = N56_annealed_IV(:,2);
slope = diff(I)./diff(V);
slope = find(slope>0.0001|slope<-0.0001);
V = V(slope(1):(slope(end)+1));
I = I(slope(1):(slope(end)+1));
[fit_100,gof_100,xd,yd] = LinearFit(V,I);
plot(xd,yd,'kx');hold on; 
plot(fit_100,'k-','predfunc');hold on;

title('Comparison Between Contact IV Curves');
xlim([-0.21,0.21]);
ylim([-0.11,0.11]);
xlabel('V');
ylabel('I');
legend('d=1500','','','','d=750','','','','d=500','','','','d=250','','','','d=100');
grid on;

%% Resistance vs distance graph
%R = 1/slope
close all

%calculating Resistances 
R_1500 = 1/fit_1500.p1;
Ranges = confint(fit_1500);
R_1500_err = ((Ranges(2,1)-fit_1500.p1)/fit_1500.p1)*R_1500;
plot(1500, R_1500,'r+');hold on;

R_750 = 1/fit_750.p1;
Ranges = confint(fit_750);
R_750_err = ((Ranges(2,1)-fit_750.p1)/fit_750.p1)*R_750;
%plot(750, R_750,'r+');hold on;

R_500 = 1/fit_500.p1;
Ranges = confint(fit_500);
R_500_err = ((Ranges(2,1)-fit_500.p1)/fit_500.p1)*R_500;
plot(500, R_500,'r+');hold on;

R_250 = 1/fit_250.p1;
Ranges = confint(fit_250);
R_250_err = ((Ranges(2,1)-fit_250.p1)/fit_250.p1)*R_250;
plot(250, R_250,'r+');hold on;

R_100 = 1/fit_100.p1;
Ranges = confint(fit_100);
R_100_err = ((Ranges(2,1)-fit_100.p1)/fit_100.p1)*R_100;
plot(100, R_100,'r+');hold on;

Rs = [R_100, R_250, R_500,R_1500];
ds = [100,250,500,1500];

%applying a fit to the resistances 
[R_fit,gof,xd,yd] = LinearFit(ds,Rs);
figure();
plot(xd,yd,'x');hold on;
plot(R_fit,'predfunc');
title('Resistance vs Distance')
xlabel('Spacing (\mum)')
ylabel('Resistance (\Omega)')
legend('Data','Fit','Bounds');
grid on;
%% Display 
clc
cprintf('        '); cprintf(-[1,0,1],  'Resistances from IV Curves ');
table([100,250,500,750,1500]',[R_100, R_250, R_500, R_750,R_1500]',[R_100_err, R_250_err, R_500_err, R_750_err,R_1500_err]','VariableNames',{'Distance','Value','Uncertainty'})%,'RowNames',{'d = 1500','d = 750','d = 500','d =250','d = 100'})

%% resistivity calculations 
A = (1500)*(250); %in mm^2
%Rc = intercept/2

%contact resistance 
Rc = R_fit.p2/2; %in ohms
Rc_err = ((Ranges(2,2)-R_fit.p2)/R_fit.p2)*Rc;

%specific contact reistivity
pc = Rc*A*((0.1)^2);%in ohms*cm^2
%for error 
Ranges = confint(R_fit);
pc_err = ((Ranges(2,2)-R_fit.p2)/R_fit.p2)*pc;

%% Display

cprintf('         '); cprintf(-[1,0,1],  'Resistance Characteristics ');
table([Rc,pc]',[Rc_err,pc_err]','VariableNames',{'Value','Uncertainty'},'RowNames',{'Rc','pc'})
