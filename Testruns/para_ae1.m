

% para_ae1.m show the analysis of PARAFAC according to the parademo.m from nway toolbox
% Comments are tentaviely and should be Scrutinized more extensively. 
% Data are preloaded. The macro parademo.m has been changed to suit our
% case and with comments as far as this is possible. 
% Reslts of loadings corresponds to Ex (mode 3) and Em (mode 2) spectra 
% The scores corresponds to the concentrations of the different solutions.
% Knut Kvaal, WESH, NMBU
% 
%
% REQUIRES THE DATA SETS !!!!!
%

% Copyright (C) 1995-2006  Rasmus Bro & Claus Andersson
% Copenhagen University, DK-1958 Frederiksberg, Denmark, rb@life.ku.dk
%
% This program is free software; you can redistribute it and/or modify it under 
% the terms of the GNU General Public License as published by the Free Software 
% Foundation; either version 2 of the License, or (at your option) any later version.
%
% This program is distributed in the hope that it will be useful, but WITHOUT 
% ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS 
% FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.
% You should have received a copy of the GNU General Public License along with 
% this program; if not, write to the Free Software Foundation, Inc., 51 Franklin 
% Street, Fifth Floor, Boston, MA  02110-1301, USA.


close all
clear all
echo off
home
echo on

% Datasets an_ae_data2 are prepared as multivay data using PLS_Toolbox. The
% dataset type data has been exported to nway data suited for the nway
% toolbox.
% 
load an_ae_data2;
echo off

disp(' ')
disp(' Fluorescence measurements ideally follow the trilinear PARAFAC')
disp(' model. We will use a simple data set of 5 mixtures of three')
disp(' amino-acids (trp,phe & tyr) to show how the pure spectra and')
disp(' concentrations can be found with parafac')
disp(' ')
disp(' First lets look at the raw data:')
disp(' Press any key to continue')
pause

% Change this for new X
X=ae_raw;
%X=an_raw;
% Emission and Exitation Axis values for this type of data.
EmAx = Em_txt_Ax;
ExAx = Ex_txt_Ax;

max_X=max(max(max(X)));
echo on
figure(1);
for i=1:5,
   subplot(3,2,i)
   sample = squeeze(X(i,:,:));
   mesh(ExAx,EmAx,sample);
   title(['Raw data - sample ',num2str(i)]);
   xlabel('Excitation [nm]')
   ylabel('Emission [nm]')
   axis([ExAx(1) ExAx(end) EmAx(1) EmAx(end) 0 max_X]);
   grid on
   drawnow
end;
echo off

disp(' ')
disp(' Press any key to continue')
pause
close all
home

% disp(' ')
% disp(' The data will be slightly reduced to save computation time. This is done')
% disp(' by reducing the 2. and 3. emission and excitation mode:')
% disp(' ')
% 
% echo on
% X = X(:,1:5:end,1:2:end);
% EmAx = Em_txt_Ax(1:5:end);
% ExAx = Ex_txt_Ax(1:5:end);
% size(X)
% echo off
% 
% disp(' ')
% disp(' Press any key to continue')
% pause
close all
home


disp(' ')
disp(' PARAFAC may be fitted to the data, but in order to investigate how')
disp(' many components are needed we will use the tool pftest to get an')
disp(' indication. We use 1 to 5 components because we assume that appr.')
disp(' 3 are reasonable but want to check that. We fit models from 1 to 5 ')
disp(' components and fit each three times. This way we can check that the')
disp(' is the same every time we fit, say a four-component model. If it is')
disp(' it is an indication that we have used too many components or that the')
disp('  data are difficult to fit')
disp(' ')
disp(' This process will take some time, but afterwards a plot is produced')
disp(' which is often very instructive to look at')
disp(' ')
disp(' ')
disp(' Press any key to continue')
disp(' ')
pause
close all
home

echo on
[ssX,Corco] = pftest(3,X,5,[0 0 0 0 NaN]);
echo off 
disp(' ')
disp(' Indeed, the fit values seem to indicate that two components are ')
disp(' suitable, whereas the core consistency seems to point to a possible')
disp(' third component. This third component must be weak though considering')
disp(' the low increase in fit. If looking into the 2- and 3-component models')
disp(' it is realized that the third component could be is reflecting Rayleigh scatter.')
disp(' The problem could have been avoided if we remove emission below ')
disp(' excitation (by setting these elements to NaN), but this is not pursued')
disp(' here. Instead, we will fit a two-component parafac model.')
disp(' --> Due to the high core constency of the 3. component one could also try to')
disp(' Investigate if this is a real data component.')


disp(' ')
disp(' We will turn the plotting on, so that a graphical output is produced')
disp(' ') 
disp(' Press any key to continue')
pause
close all
home

echo on
% 2 components for ae_raw
% 2-3 components for an_raw
model = parafac(X,2,[0 0 2]);
echo off 

disp(' ') 
disp(' Press any key to continue')
pause
close all
home

disp(' Using the function fac2let, we can get scores and loading out')
disp(' ')
echo on
[A,B,C] = fac2let(model);
echo off
disp(' ')
disp(' Scores')
disp(A)
disp(' ')
disp(' Concentrations')
%disp(y)
disp(' ')
%disp(readme)
disp(' ')

disp(' Scrutinize the scores and compare to the concentrations to see')
disp(' the relation between the two. Each score correspond to a specific')
disp(' component up to scale and permutation')
disp(' ')
disp(' END OF  PARADEMO')