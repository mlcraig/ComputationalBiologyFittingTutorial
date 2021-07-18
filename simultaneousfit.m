function [param_fit,controlfit_time,controlfit_S,fullfit_time,fullfit_S,fullfit_T] = simultaneousfit(p,data)

%load parameters to be fit
param_guess = [p.r,p.K,p.kappa,p.a,p.d];

%set lower and upper bounds on parameters
lb = [0 0 0 0 0];
ub = [Inf Inf Inf Inf Inf];

%call the optimizer (here lsqnonlin--returns a vector of residuals at each
%sampling point in the data
[param_fit,resnorm,residual,exitflag,output,lambda,jacobian] = lsqnonlin(@residualsfunction, param_guess, lb, ub,[]);   % Invoke optimizer

%Set parameter values to return to commands after returning from optimizer
r = param_fit(1);
K = param_fit(2);
kappa = param_fit(3);
a = param_fit(4);
d = param_fit(5);

%simulate solutions with new parameter values
initialcondition = [p.S0];
sol = ode45(@controlmodel,[0 data.time(end)],initialcondition);
controlfit_time = sol.x;
controlfit_S = sol.y;
    
initialcondition = [p.S0,p.T0];
sol = ode45(@fullmodel,[0 data.time(end)],initialcondition);
fullfit_time = sol.x;
fullfit_S = sol.y(1,:);
fullfit_T = sol.y(2,:);

%------------------------------------------------------------------------
function val = residualsfunction(param)

    %set values of parameters
    r = param(1);
    K = param(2);
    kappa = param(3);
    a = param(4);
    d = param(5);
    
    %simulate each model (without and with treatment)
    initialcondition = [p.S0];
    sol = ode45(@controlmodel,[0 data.time(end)],initialcondition);
    val_control = deval(sol,data.time,1)-data.control;
    
    initialcondition = [p.S0,p.T0];
    sol = ode45(@fullmodel,[0 data.time(end)],initialcondition);
    val_treatment = deval(sol,data.time,1)-data.treatment;
    
    %calculate residuals
    val = [val_control val_treatment];
    sum(abs(val))

end
%------------------------------------------------------------------------
function dydt = controlmodel(t,y,Z)
   S = y(1);
   
   dS = r*S*(1-S/K);

   dydt = [dS];

end
%------------------------------------------------------------------------
function dydt = fullmodel(t,y,Z)
   S = y(1);
   T = y(2);
   
   dS = r*S*(1-S/K)-kappa*S*T;
   dT = a*S-d*T;

   dydt = [dS;dT];

end
%------------------------------------------------------------------------
end