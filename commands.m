%% fitting model parameters to data

load('Tumour_growth_data.mat') %load in experiment data

%set up matlab variable for the data
data.time = experiment_time;                                               %experiment time points
data.control = control_tumour_volume_mean;                                 %control experiment tumour volume mean  
data.std_control = control_tumour_volume_std;                              %control experiment tumour volume standard deviation
data.treatment = treatment_tumour_volume_mean;                             %immune experiment tumour size mean  
data.std_treatment = treatment_tumour_volume_mean;                         %immune experiment tumour volume standard deviation

%set parameter values
p.S0 = 100;                                                                 %initial tumour volume
p.T0 = 0;                                                                   %initial number of T cells

p.r = 1;                                                                    %tumour cell replication rate
p.K = 10000;                                                                %tumour carrying capacity
p.kappa = 0.0001;                                                           %T cell killing of tumour cells rate
p.a = 1;                                                                    %T cell activation rate
p.d = 1;                                                                    %T cell death rate

%function to simultaneously fit control and immune experiment data
[param_fit,controlfit_time,controlfit_S,fullfit_time,fullfit_S,fullfit_T] = simultaneousfit(p,data); 

%obtain fitted parameter values
r = param_fit(1);
K = param_fit(2);
kappa = param_fit(3);
a = param_fit(4);
d = param_fit(5);

%display parameter values in command window
disp(['r = ',num2str(r)])
disp(['K = ',num2str(K)])
disp(['kappa = ',num2str(kappa)])
disp(['a = ',num2str(a)])
disp(['d = ',num2str(d)])

%plot control fit
figure
hold on 
errorbar(data.time,data.control,data.std_control,'LineWidth',2)
plot(controlfit_time,controlfit_S,'k:','LineWidth',2)
xlabel('Time (days)')
ylabel('Tumour volume')
legend('Tumour volume measurement','Tumour cells, S(t)')
set(gca,'FontSize',16)
title('Control')

%plot immune experiment fit
figure
hold on 
errorbar(data.time,data.treatment,data.std_treatment,'Color',[0.51, 0.78, 0.95],'LineWidth',2)
plot(fullfit_time,fullfit_S,'k:','LineWidth',2)
ylabel('Tumour volume')
xlabel('Time (days)')
set(gca,'FontSize',16)
ylim([0 4500])
legend('Tumour volume measurement','Tumour cells, S(t)')
title('Immune treatment')

%plot T cells
figure
plot(fullfit_time,fullfit_T,'Color',[0.19,0.67,0.65],'LineWidth',2)
xlabel('Time (days)')
ylabel('Number of T cells')
set(gca,'FontSize',16)
legend('T cells, T(t)')
title('Immune treatment')