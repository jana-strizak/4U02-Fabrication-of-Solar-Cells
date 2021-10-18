function [fitresult, gof, xData, yData] = LinearFit(x, y)
%CREATEFIT(V,I)
%  Create a fit.
%
%  Data for 'untitled fit 1' fit:
%      X Input : V
%      Y Output: I
%  Output:
%      fitresult : a fit object representing the fit.
%      gof : structure with goodness-of fit info.
%
%  See also FIT, CFIT, SFIT.

%  Auto-generated by MATLAB on 11-Dec-2019 20:32:51


%% Fit: 'untitled fit 1'.
[xData, yData] = prepareCurveData(x,y);

% Set up fittype and options.
ft = fittype( 'poly1' );

% Fit model to data.
[fitresult, gof] = fit( xData, yData, ft );

% Plot fit with data.
%figure();
%h = plot( fitresult, xData, yData );
%legend( h, 'I vs. V', 'untitled fit 1', 'Location', 'NorthEast' );
% Label axes
%xlabel V
%ylabel I
%grid on
end

