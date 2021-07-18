function [controlmodel_S] = simulated_fullmodel(r,K,kappa,a,d,p,data)

initialcondition = [p.S0,p.T0];
sol = ode45(@fullmodel,[0 data.time(end)],initialcondition);
controlmodel_S = deval(sol,data.time,1);

function dydt = fullmodel(t,y,Z)
   S = y(1);
   T = y(2);
   
   dS = r*S*(1-S/K)-kappa*S*T;
   dT = a*S-d*T;

   dydt = [dS;dT];

end

end