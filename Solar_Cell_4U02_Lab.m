clc 
close all;
clear all;
%this program will calculate the solar cell equation, properties, and efficiencies 
path(path,'C:\\Users\\janas\\OneDrive\Documents\5th Year\4U02 - Lab\rytylucys_AMAZING_postcutting diode curves');
load('IV_curves_matlabform.mat')

%% Efficiency calculation of NE cell
%must set V,I dark and light, as well as area of cell for each
close all
V_dark = NE_dark(:,1);
I_dark = NE_dark(:,2);
%dark equation I = I_o*exp(bV) - I_o
% which can be fit to y = a*exp(bx)-c
[fit_dark,xd1,yd1,gof, output] = DiodeEqu(V_dark,I_dark,'Dark NE Cell');

figure();
pNEl = plot(fit_dark,'r', xd1, yd1,'xr','predfunc');hold on;

V_light = NE_light(:,1);
I_light = NE_light(:,2);
[fit_light,xd2,yd2, ~, ~] = DiodeEqu(V_light,I_light,'Light NE Cell');

figure();
pNEd = plot(fit_light,'b', xd2, yd2,'xb','predfunc');hold on;
legend([pNEl(2),pNEd(2)],{'NE dark','NE light'});
title('NE IV Curves');
xlabel V
ylabel I
grid on 

%light Diode Equation 
[FF, P_max, I_max, V_max, V_sc, I_oc, R_sh,R_s,err]  = solarcellparameters(fit_light,'NE',xd);

%efficiency based on input power
%A = 1.4*0.9; %Area of NE cell
%P_lamp = A*60e-3;
%eff_NE = P_max/P_lamp
syms eff(P,x,y,lum)
eff(P,x,y,lum) = P/(x*y*lum);
eff_NE = eval(eff(P_max,1.4,0.9,60e-3));
%error 
eff_NE_err = PropError(eff,[P,x,y,lum],[P_max,1.4,0.9,60e-3],[err(2),0.05,0.05,1e-1]);

NEd = fit_dark;
NEl = fit_light;
%% Display Curve Fit Info 
range_dark = confint(fit_dark);
range_light = confint(fit_light);

a = [fit_dark.a,fit_light.a];
aError = [(range_dark(2,1)-fit_dark.a), (range_light(2,1)-fit_light.a)];

b = [fit_dark.b,fit_light.b];
bError = [(range_dark(2,2)-fit_dark.b), (range_light(2,2)-fit_light.b)];

c = [fit_dark.c,fit_light.c];
cError = [(range_dark(2,3)-fit_dark.c), (range_light(2,3)-fit_light.c)];


%table(FittedCurve',a',aError',b',bError',c',cError','VariableNames',{'f','s','d','f','y','y'})
cprintf('                               '); cprintf(-[1,0,1],  'NE IV Curve Fitting Parameters ');
table(a',aError',b',bError',c',cError','VariableNames',{'a','aError','b','bError','c','cError'},'RowNames',{'Dark Curve','Light Curve'})

%% Display Solar Cell Parameters 

cprintf('            '); cprintf(-[1,0,1],  'NE Solar Cell Values ');
table([FF,P_max,I_max,V_max,V_sc,I_oc,R_sh,R_s,eff_NE]',[err eff_NE_err]','VariableNames',{'Value','Uncertainty'},'RowNames',{'FF','Pmax(W)','Imax(A)','Vmax(V)','Voc(V)','Isc(A)','Rsh(Ohms)','Rs(Ohms)','Efficiency'})

%% Efficiency calculation of NW cell
%must set V,I dark and light, as well as area of cell for each
close all
V_dark = NW_dark(:,1);
I_dark = NW_dark(:,2);
%dark equation I = I_o*exp(bV) - I_o
% which can be fit to y = a*exp(bx)-c
[fit_dark,xd1,yd1,~, ~] = DiodeEqu(V_dark,I_dark,'Dark NW Cell');

V_light = NW_light(:,1);
I_light = NW_light(:,2);
[fit_light,xd2,yd2 ~, ~] = DiodeEqu(V_light,I_light,'Light NW Cell');

figure();
pNWd = plot(fit_dark,'r', xd1, yd1,'xr','predfunc');hold on;
pNWl = plot(fit_light,'b', xd2, yd2,'xb','predfunc');hold on;
legend([pNWd(2),pNWl(2)],{'NW dark','NW light'});
title('NW IV Curves');
xlabel V
ylabel I
grid on 

%light Diode Equation 
[FF, P_max, I_max, V_max, V_sc, I_oc, R_sh,R_s,err]  = solarcellparameters(fit_light,'NW',xd);

% %efficiency based on input power
% A = 1.9; %Area of NW cell
% P_lamp = A*60e-3;
% eff_NW = P_max/P_lamp

syms eff(P,x,y,lum)
eff(P,x,y,lum) = P/(x*y*lum);
eff_NW = eval(eff(P_max,1.4,1.4,60e-3));
%error 
eff_NW_err = PropError(eff,[P,x,y,lum],[P_max,1.4,1.4,60e-3],[err(2),0.05,0.05,1e-1]);

NWd = fit_dark;
NWl = fit_light;
%% Display Curve Fit Info 
range_dark = confint(fit_dark);
range_light = confint(fit_light);

a = [fit_dark.a,fit_light.a];
aError = [(range_dark(2,1)-fit_dark.a), (range_light(2,1)-fit_light.a)];

b = [fit_dark.b,fit_light.b];
bError = [(range_dark(2,2)-fit_dark.b), (range_light(2,2)-fit_light.b)];

c = [fit_dark.c,fit_light.c];
cError = [(range_dark(2,3)-fit_dark.c), (range_light(2,3)-fit_light.c)];


cprintf('                               '); cprintf(-[1,0,1],  'NW IV Curve Fitting Parameters ');
table(a',aError',b',bError',c',cError','VariableNames',{'a','aError','b','bError','c','cError'},'RowNames',{'Dark Curve','Light Curve'})

%% Display Solar Cell Parameters 
cprintf('            '); cprintf(-[1,0,1],  'NW Solar Cell Values ');
table([FF,P_max,I_max,V_max,V_sc,I_oc,R_sh,R_s,eff_NW]',[err eff_NW_err]','VariableNames',{'Value','Uncertainty'},'RowNames',{'FF','Pmax(W)','Imax(A)','Vmax(V)','Voc(V)','Isc(A)','Rsh(Ohms)','Rs(Ohms)','Efficiency'})

%% Efficiency calculation of SE cell
%must set V,I dark and light, as well as area of cell for each
close all
V_dark = SE_dark(:,1);
I_dark = SE_dark(:,2);
%dark equation I = I_o*exp(bV) - I_o
% which can be fit to y = a*exp(bx)-c
[fit_dark,xd1,yd1, ~ , ~] = DiodeEqu(V_dark,I_dark,'Dark SE Cell');

V_light = SE_light(:,1);
I_light = SE_light(:,2);
[fit_light,xd2,yd2, ~ , ~] = DiodeEqu(V_light,I_light,'Light SE Cell');

figure();
pSEd = plot(fit_dark,'r', xd1, yd1,'xr','predfunc');hold on;
pSEl = plot(fit_light,'b', xd2, yd2,'xb','predfunc');hold on;
legend([pSEd(2),pSEl(2)],{'SE dark','SE light'});
title('SE IV Curves');
xlabel V
ylabel I
grid on 

%light Diode Equation 
[FF, P_max, I_max, V_max, V_sc, I_oc,R_sh,R_s, err]  = solarcellparameters(fit_light,'SE',xd);

%efficiency based on input power
% A = 1.9; %Area of SE cell
% P_lamp = A*60e-3;
% eff_SE = P_max/P_lamp

syms eff(P,x,y,lum)
eff(P,x,y,lum) = P/(x*y*lum);
eff_SE = eval(eff(P_max,1.4,1.4,60e-3));
%error 
eff_SE_err = PropError(eff,[P,x,y,lum],[P_max,1.4,1.4,60e-3],[err(2),0.05,0.05,1e-1]);

SEd = fit_dark;
SEl = fit_light;
%% Display Curve Fit Info 
range_dark = confint(fit_dark);
range_light = confint(fit_light);

a = [fit_dark.a,fit_light.a];
aError = [(range_dark(2,1)-fit_dark.a), (range_light(2,1)-fit_light.a)];

b = [fit_dark.b,fit_light.b];
bError = [(range_dark(2,2)-fit_dark.b), (range_light(2,2)-fit_light.b)];

c = [fit_dark.c,fit_light.c];
cError = [(range_dark(2,3)-fit_dark.c), (range_light(2,3)-fit_light.c)];

FittedCurve = {'Dark','Light'};

cprintf('                               '); cprintf(-[1,0,1],  'SE IV Curve Fitting Parameters ');
table(a',aError',b',bError',c',cError','VariableNames',{'a','aError','b','bError','c','cError'},'RowNames',{'Dark Curve','Light Curve'})

%% Display Solar Cell Parameters 
cprintf('            '); cprintf(-[1,0,1],  'SE Solar Cell Values ');
table([FF,P_max,I_max,V_max,V_sc,I_oc,R_sh,R_s,eff_SE]',[err eff_SE_err]','VariableNames',{'Value','Uncertainty'},'RowNames',{'FF','Pmax(W)','Imax(A)','Vmax(V)','Voc(V)','Isc(A)','Rsh(Ohms)','Rs(Ohms)','Efficiency'})

%% Efficiency calculation of SW cell
%must set V,I dark and light, as well as area of cell for each
close all
V_dark = SW_dark(:,1);
I_dark = SW_dark(:,2);
%dark equation I = I_o*exp(bV) - I_o
% which can be fit to y = a*exp(bx)-c
[fit_dark,xd1,yd1, ~, ~] = DiodeEqu(V_dark,I_dark,'Dark SW Cell');

V_light = SW_light(:,1);
I_light = SW_light(:,2);
[fit_light,xd2,yd2, ~, ~] = DiodeEqu(V_light,I_light,'Light SW Cell');

figure();
pSWd = plot(fit_dark,'r', xd1, yd1,'xr','predfunc');hold on;
pSWl = plot(fit_light,'b', xd2, yd2,'xb','predfunc');hold on;
legend([pSWd(2),pSWl(2)],{'SW dark','SW light'});
title('SW IV Curves');
xlabel V
ylabel I
grid on 


%light Diode Equation 
[FF, P_max, I_max, V_max, V_sc, I_oc,R_sh,R_s,err]  = solarcellparameters(fit_light,'SW',xd);

%efficiency based on input power
% A = 1.35*0.4; %Area of SW cell
% P_lamp = A*60e-3;
% eff_SW = P_max/P_lamp

syms eff(P,x,y,lum)
eff(P,x,y,lum) = P/(x*y*lum);
eff_SW = eval(eff(P_max,1.35,0.4,60e-3));
%error 
eff_SW_err = PropError(eff,[P,x,y,lum],[P_max,1.35,0.4,60e-3],[err(2),0.05,0.05,1e-1]);

SWd = fit_dark;
SWl = fit_light;
%% Display Curve Fit Info 
range_dark = confint(fit_dark);
range_light = confint(fit_light);

a = [fit_dark.a,fit_light.a];
aError = [(range_dark(2,1)-fit_dark.a), (range_light(2,1)-fit_light.a)];

b = [fit_dark.b,fit_light.b];
bError = [(range_dark(2,2)-fit_dark.b), (range_light(2,2)-fit_light.b)];

c = [fit_dark.c,fit_light.c];
cError = [(range_dark(2,3)-fit_dark.c), (range_light(2,3)-fit_light.c)];

FittedCurve = {'Dark','Light'};

cprintf('                               '); cprintf(-[1,0,1],  'SW IV Curve Fitting Parameters ');
table(a',aError',b',bError',c',cError','VariableNames',{'a','aError','b','bError','c','cError'},'RowNames',{'Dark Curve','Light Curve'})

%% Display Solar Cell Parameters 
cprintf('            '); cprintf(-[1,0,1],'SW Solar Cell Values ');
table([FF,P_max,I_max,V_max,V_sc,I_oc,R_sh,R_s,eff_SW]',[err eff_SW_err]','VariableNames',{'Value','Uncertainty'},'RowNames',{'FF','Pmax(W)','Imax(A)','Vmax(V)','Voc(V)','Isc(A)','Rsh(Ohms)','Rs(Ohms)','Efficiency'})

%% Display all efficienies 
cprintf('          '); cprintf(-[1,0,1],'All Quadrant Efficiencies ');
table([eff_NE, eff_NW, eff_SE, eff_SW]',[eff_NE_err, eff_NW_err, eff_SE_err, eff_SW_err]','VariableNames',{'Efficiency','Uncertainty'},'RowNames',{'NE','NW','SE','SW'})

%% plotting all light cuvres
close all
figure();
p1 = plot(NEl,'r','predfunc');hold on;
p2 = plot(NWl,'b','predfunc');hold on;
p3 = plot(SEl,'m','predfunc');hold on;
p4 = plot(SWl,'k','predfunc');hold on;
grid on
legend([p1(1),p2(1),p3(1),p4(1)],{'NE','NW','SE','SW'});
xlabel V
ylabel I
title('Comparison of Light Curves');

figure();
p5 = plot(NEd,'r','predfunc');hold on;
p6 = plot(NWd,'b','predfunc');hold on;
p7 = plot(SEd,'m','predfunc');hold on;
p8 = plot(SWd,'k','predfunc');hold on;
grid on
legend([p5(1),p6(1),p7(1),p8(1)],{'NE','NW','SE','SW'});
xlabel V
ylabel I
title('Comparison of Light Dark');