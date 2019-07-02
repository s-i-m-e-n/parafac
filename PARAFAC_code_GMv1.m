% Set Home Directory (homedir) and navigate to 'homedir'
clear all, close all, clc
homedir='U:\Simen';
cd(homedir)

% Set defaults
set(0,'DefaultFigureColor','White',...
    'DefaultAxesFontSize',14,...
    'DefaultTextFontSize',1.5,...
    'DefaultAxesFontName','<Arial>',...
    'DefaultTextFontName','<Arial>',...
    'DefaultLineMarkerSize',14,...
    'DefaultLineLineWidth', 1.5);

% Set Working Directory (wkdir) and navigate to 'wkdir'
wkdir='./eem_cor';
cd(wkdir)

% storing excitation and emission wavelength data in 'ex' and 'em'
% respectively
ex = table2array(readtable('Ex.txt','ReadVariableNames',false));
em = table2array(readtable('Em.txt','ReadVariableNames',false));

% Store names of eem files in 'filenames'
filenames = dir('S14*.txt');

% Store data for all EEMs in a 3D array 'X'
X = zeros(length(filenames),length(em),length(ex));

for n=1:length(filenames)
    X(n,:,:) = table2array(readtable(filenames(n).name,'ReadVariableNames',false));
end

% Plot contour plots of all eems in one figure
figure(1)
for i=1:length(filenames)
    d = divisors(length(filenames));
    m = d(floor(length(d)/2));
    n = d(floor(length(d)/2)+1);
    subplot(m,n,i)
    mesh(ex, em, squeeze(X(i,:,:))); axis tight
end

% Plot all eems in one figure
figure(2)
for i=1:length(filenames)
    d = divisors(length(filenames));
    m = d(floor(length(d)/2));
    n = d(floor(length(d)/2)+1);
    subplot(m,n,i)
    eem = zeros(length(em),length(ex));
    eem(:,:) = X(i,:,:);
    
    zeroNegative = @(x) ((x+abs(x))/2+0.0001); %actually set to 0.0001 so can create a log plot
    eem = zeroNegative(eem);
    
    tit = sprintf('Sample %d',i);
    xLimits=[220 500];
    yLimits=[250 550];
    levels=linspace(0,max(max(eem)),10);
    fig=gcf;
    fig.Position=[0 0 1200 1600];
    contourf(ex, em, eem,...
                    'LineStyle','none',... %Turn off lines between countour levels
                    'LevelList',levels); %scale based on max level
                
                %Graph display options
                box on %Creates solid box around graph
                set(gca,'linewidth',1.5,'FontWeight', 'bold', 'FontSize', 14) %Sets width of box around graph and axis label text size
                xlabel('\lambda_{ex}','FontWeight','bold','FontSize',14);
                ylabel('\lambda_{em}','FontWeight','bold','FontSize',14);
                title(tit,'FontSize', 14)
                colorbar
                set(gca,'Xlim',xLimits,'YLim',yLimits,...              %# Set the limits and the
                    'DataAspectRatio',[1 1 1]);
end



% Set 'nway_dir' as path to the nway toolbox and nagate to 'nway_dir'
nway_dir = 'U:\nway331';
cd(nway_dir);

%% Determining the proper number of components/factors
% Investigate the fits of a one-, two- and three-component PARAFAC model of 
% the data. Try also to estimate a four-component model.
max_factors = 3;

% Store sum of squares error and number of iterations for each model in
% 'err' and 'it' respectively
err = zeros(1,max_factors);
it = zeros(1,max_factors);

% Store core consistency for each model in cf
cf = zeros(1,max_factors);

for i=1:max_factors
    
    % Fitting the PARAFAC model
    [model,it(i),err(i)] = parafac(X,i);
    % Where X is the data and i is the number of factors to extract.
    
    % Calculate and store core consistency of model
    cf(1,i) = corcond(X,model);
end

%% pftest
% pftest(t,X,max_factors) is used to check residual sum of squares, core 
% consistency and number of iterations required to reach convergence 
% 't' times for factors from 1 to max_factors
[ssX,Corco,It] = pftest(5,X,max_factors);

%% Checking convergence of the algorithm
% Estimate the model several times and compare fit values
% For some data the model is very difficult to fit and a lower convergence
% criterion may therefore be needed
Options=[]; 
Options(1)=1e-7;

Options(2)=2; % We need to start from different places every time 
[Factors1,it1,err1] = parafac(X,2,Options);

Options(2)=10;
[Factors2,it2,err2] = parafac(X,2,Options);

%% Analysis with final model
% Fix the number of components/factors
n_comp = 2;

% Determine model based on the fixed number of components
model = parafac(X,n_comp);
X = nmodel(model);
[A,B,C] = fac2let(model);

% Store EEM of components in 'Components'
Components = zeros(n_comp,length(em),length(ex));

% Plot components
figure(3)
for i=1:n_comp
    for j=1:length(ex)
        for k=1:length(em)
            Components(i,k,j) = B(k,i)*C(j,i);
        end
    end
    
    d = divisors(n_comp);
    m = d(floor(length(d)/2));
    n = d(floor(length(d)/2)+1);
    
    
    subplot(m,n,i)
    
    eem = zeros(length(em),length(ex));
    eem(:,:) = Components(i,:,:);
    
    zeroNegative = @(x) ((x+abs(x))/2+0.0001); %actually set to 0.0001 so can create a log plot
    eem = zeroNegative(eem);
    
    tit = sprintf('Component %d',i);
    xLimits=[220 500];
    yLimits=[250 550];
    levels=linspace(0,max(max(eem)),10);
    fig=gcf;
    fig.Position=[0 0 1200 1600];
    contourf(ex, em, eem,...
                    'LineStyle','none',... %Turn off lines between countour levels
                    'LevelList',levels); %scale based on max level
                
                %Graph display options
                box on %Creates solid box around graph
                set(gca,'linewidth',1.5,'FontWeight', 'bold', 'FontSize', 14) %Sets width of box around graph and axis label text size
                xlabel('\lambda_{ex}','FontWeight','bold','FontSize',14);
                ylabel('\lambda_{em}','FontWeight','bold','FontSize',14);
                title(tit,'FontSize', 14)
                colorbar
                set(gca,'Xlim',xLimits,'YLim',yLimits,...              %# Set the limits and the
                    'DataAspectRatio',[1 1 1]);
    
end


% Plot scores corresponding to each component for all EEMs
figure(4)
for i=1:length(filenames)
    d = divisors(length(filenames));
    m = d(floor(length(d)/2));
    n = d(floor(length(d)/2)+1);
    subplot(m,n,i)
    bar(A(i,:));
    xlabel('Component');
    ylabel('Relative Conc.');
end



