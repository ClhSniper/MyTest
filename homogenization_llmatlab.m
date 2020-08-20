
% Load the model containing the transient diffusion problem.
model = mphopen('homogenization_llmatlab');
%%
% Run a loop for 5 iterations.
for i = 1:5
    % Solve the model.
    model.study('std1').run;
    % Extract the concentration at point (25e-2;25e-2;5e-2) and the time
    % value for each time step.
    [t,c] = mphinterp(model,{'t','c'},...
        'coord',[25e-2;25e-2;25e-2],...
        'unit',{'h','mol/m^3'});
    % Evaluate the concentration average in the tank. 
    c_av = mphmean(model,'c','volume','solnum','end');
    % Retreive the latest time step value.
    t0 = mphglobal(model,'t','solnum','end');
    % Set the initial value for the species concentration with the average
    % value c_av.
    model.physics('tds').feature('init1').set('initc', 1, c_av);
    % Update the initial time for the new calculation.
    model.param.set('t0',t0);    
    % Plot the concentration value versus the time.
    plot(t,c)
    hold on
    disp(sprintf('End of iteration No.%d',i));
end
%% 
%Add plot settings.
title('concentration at (25e-2;25e-2;25e-2) vs time')
xlabel('[h]');
ylabel('[mol/m^3]')
%% 
% Compute the same problem without the homogenization process
% Set initial and final value.
model.param.set('t0',0);
model.param.set('tf','2.5[h]');
% Set the initial concentration to 0.
model.physics('tds').feature('init1').set('initc', 1, 0);
% Solve the model.
model.study('std1').run;
%%
% Evaluate the concentration and plot the result on the current figure.
[t,c] = mphinterp(model,{'t','c'},...
    'coord',[25e-2;25e-2;25e-2],...
    'unit',{'h','mol/m^3'});
plot(t,c,'r-.')
%
% Display the concentration on a 3D surface plot.
model.result.create('pg1', 'PlotGroup3D');
model.result('pg1').feature.create('surf1', 'Surface');
model.result('pg1').set('solnum', '11');
figure
mphplot(model,'pg1','rangenum',1)
