function [FF, P_max, I_max, V_max, V_sc, I_oc,R_shunt,R_s,Error]  = solarcellparameters(fit_light,text,xd)
%this function will take in the fitted diode equation for a solar cell and
%output the solar cell parameters such as efficiency and max power
% equation parameters in first quadrant

%defining functions for error propagation 
syms I_err(V_1, a, b, c)
I_err(V_1, a, b, c) = (-1)*(a*exp(b*V_1)-c); %just for error calculations

syms V_err(a2, b2, c2, I_1)
V_err(a2, b2, c2, I_1) = (1/b2)*log((c2-I_1)/a2); %for solving roots

%starting actual calculations
I = @(V)(-1)*(fit_light.a*exp(fit_light.b*V)-fit_light.c);
figure(); %plotting solar cell curve
fplot(I,'b'); hold on;
pred = predint(fit_light,xd,0.95,'functional','on'); %curve error
plot(xd,(-1*pred),':b'); hold on; %error is also reflected before plotting
grid on;
%Errors
Ranges = confint(fit_light);

%evaluation of parameters 
I_oc = I(0); %current when V = 0
I_oc_err = PropError(I_err,[V_1,a,b,c],[0,fit_light.a,fit_light.b,fit_light.c],[0,(Ranges(2,1)-fit_light.a),(Ranges(2,2)-fit_light.b),(Ranges(2,3)-fit_light.c)]);

V_sc = fzero(I,0);
V_sc_err = PropError(V_err,[a2,b2,c2,I_1],[fit_light.a,fit_light.b,fit_light.c,0],[(Ranges(2,1)-fit_light.a),(Ranges(2,2)-fit_light.b),(Ranges(2,3)-fit_light.c),0]);

plot(0, I_oc,'r*');hold on;
plot(V_sc,0,'r*'); hold on;
xlim([0,V_sc]); ylim([0,I_oc]);

% Finding Max Power 
P_max = [];
V_max =[];
I_max = [];
for V_step = linspace(0,V_sc,50)
    I_step = I(V_step);
    P_step = I_step*V_step;
    P_max = [P_max P_step];
    V_max = [V_max V_step];
    I_max = [I_max I_step];
end 
[P_max, index] = max(P_max);
V_max = V_max(index);
I_max = I_max(index);

%More Error 
I_max_err = PropError(I_err,[V_1,a,b,c],[V_max,fit_light.a,fit_light.b,fit_light.c],[0,(Ranges(2,1)-fit_light.a),(Ranges(2,2)-fit_light.b),(Ranges(2,3)-fit_light.c)]);
V_max_err = PropError(V_err,[a2,b2,c2,I_1],[fit_light.a,fit_light.b,fit_light.c,I_max],[(Ranges(2,1)-fit_light.a),(Ranges(2,2)-fit_light.b),(Ranges(2,3)-fit_light.c),0]);
P = I_1*V_1; %making new power FUNCTION
P_max_err = PropError(P,[I_1,V_1],[I_max,V_max],[I_max_err,V_max_err]);

%add max power to plot
plot(V_max,I_max,'m*'); hold on;
plot([V_max V_max], [0 I_max],'--m'); hold on;
plot([0 V_max], [I_max I_max],'--m'); hold off;
xlabel('V'); ylabel('I');
title(strcat(text,' Solar Cell Curve'));

%fill factor FF = P_max/(V_sc*I_oc);
syms FF_equ(P_1, V_1, I_1)
FF_equ(P_1, V_1, I_1) = (P_1)/(V_1*I_1);
%FF error 
FF = eval(FF_equ(P_max,V_sc,I_oc));
FF_err = PropError(FF_equ,[P_1,V_1,I_1],[P_max,V_sc,I_oc],[P_max_err,V_sc_err,I_oc_err]);

%shunt (slope near Isc)
syms R_sh(I1,I2,V1,V2)
R(I1,I2,V1,V2) = (V1-V2)/(I1-I2);
R_shunt = R(I_oc,I(V_max*0.8),0,V_max*0.8);
R_shunt = abs(eval(R_shunt));

V1_err = PropError(V_err,[a2,b2,c2,I_1],[fit_light.a,fit_light.b,fit_light.c,I(0)],[(Ranges(2,1)-fit_light.a),(Ranges(2,2)-fit_light.b),(Ranges(2,3)-fit_light.c),0]);
I2_err = PropError(I_err,[V_1,a,b,c],[V_max*0.8,fit_light.a,fit_light.b,fit_light.c],[0,(Ranges(2,1)-fit_light.a),(Ranges(2,2)-fit_light.b),(Ranges(2,3)-fit_light.c)]);
V2_err = PropError(V_err,[a2,b2,c2,I_1],[fit_light.a,fit_light.b,fit_light.c,I(V_max*0.8)],[(Ranges(2,1)-fit_light.a),(Ranges(2,2)-fit_light.b),(Ranges(2,3)-fit_light.c),0]);

R_sh_err = PropError(R,[I1,I2,V1,V2],[I_oc,I(V_max*0.8),0,V_max*0.8],[I_oc_err,I2_err,V1_err,V2_err]);

%series resistance (slope near Voc)
R_s = abs(eval(R(0,I(V_max*1.2),V_sc,V_max*1.2)));

I1_err =  PropError(I_err,[V_1,a,b,c],[V_sc,fit_light.a,fit_light.b,fit_light.c],[0,(Ranges(2,1)-fit_light.a),(Ranges(2,2)-fit_light.b),(Ranges(2,3)-fit_light.c)]);
I2_err =  PropError(I_err,[V_1,a,b,c],[V_max*1.2,fit_light.a,fit_light.b,fit_light.c],[0,(Ranges(2,1)-fit_light.a),(Ranges(2,2)-fit_light.b),(Ranges(2,3)-fit_light.c)]);
V2_err = PropError(V_err,[a2,b2,c2,I_1],[fit_light.a,fit_light.b,fit_light.c,I(V_max*1.2)],[(Ranges(2,1)-fit_light.a),(Ranges(2,2)-fit_light.b),(Ranges(2,3)-fit_light.c),0]);

R_s_err = PropError(R,[I1,I2,V1,V2],[0,I(V_max*1.2),V_sc,V_max*1.2],[I1_err,I2_err,V_sc_err,V2_err]);

%Error Vector 
Error = [FF_err, P_max_err, I_max_err, V_max_err, V_sc_err, I_oc_err,R_sh_err,R_s_err];
end 