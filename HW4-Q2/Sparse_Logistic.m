clear 
close all
clear all

%Data Loading
load('alzheimers/ad_data.mat')
load('alzheimers/feature_name.mat')

% Add a column for test and train data
X_train = horzcat(X_train, ones(size(X_train,1),1));
X_test = horzcat(X_test, ones(size(X_test,1),1));

% Setting up the running parameters.
params = [0.01; 0.1; 0.2; 0.3; 0.4; 0.5; 0.6; 0.7; 0.8; 0.9; 1];
AUC_vals = zeros(size(params,1), 1);
nonzero_weights = zeros(size(params,1), 1);


% Main calling loop 
for i = 1:size(params,1)
    [w, c] = logistic_l1_train(X_train, y_train, params(i));
    predictions = X_test*w + c;
    nonzero = w ~= 0;
    nonzero_weights(i) = sum(nonzero);
    [X, Y, T, AUC] = perfcurve(y_test, predictions, 1);
    AUC_vals(i) = AUC;
    plot(X, Y)
    hold on
end



% Plotting the AUC vs Regularization Graph
figure
plot(params, AUC_vals', 'LineWidth', 5, "Marker", "*")
xlabel('Regularization Parameter')
ylabel('AUC')
grid("on")
title("AUC vs Rregularization Parameter")

ax = gca;
ax.FontSize=18;
ax.TickLength = [.02, .02]; % Make tick marks longer.
ax.LineWidth = 100*0.02; % Make tick marks thicker.
hold off
saveas(gcf, 'plots/auc-vs-reg.png')
close


% Plotting the number of feature and regularization parameter
figure
plot(params, nonzero_weights', 'LineWidth', 5, "Marker", "*")
% Add labels to plot
xlabel('Regularization Parameter')
ylabel('Number of Features Selected')
title('Num Features vs Reg. Parameters')
grid("on")
ax = gca;
ax.FontSize=20;
ax.TickLength = [.02, .02]; % Make tick marks longer.
ax.LineWidth = 100*0.02; % Make tick marks thicker.
hold off
saveas(gcf, 'plots/feature-count-vs-reg.png')
close




% Main function call 
function [w, c] = logistic_l1_train(data, labels, par)
   
% Specify the options (use without modification).
    opts.rFlag = 1; % range of par within [0, 1].
    opts.tol = 1e-6; % optimization precision
    opts.tFlag = 4; % termination options.
    opts.maxIter = 5000; % maximum iterations.
    [w, c] = LogisticR(data, labels, par, opts);
end


