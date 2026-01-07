% MATLAB script to import SU2 history data and generate convergence plots.

% --- 1. Setup and Data Loading ---
filename = 'history.csv';

% Set options for reading the table to handle special characters in headers.
% 'PreserveVariableNames' ensures that spaces and other characters are handled,
% and then we can clean them up manually.
opts = detectImportOptions(filename);
opts = setvartype(opts, 'char'); % Read all as char to avoid import errors
data = readtable(filename, opts);

% Convert columns to numeric, replacing non-numeric with NaN
for i = 1:width(data)
    data.(i) = str2double(data.(i));
end

% Clean up the variable names (column headers)
% The headers are in the first row because of the quotes.
% Let's read the headers from the original file.
fid = fopen(filename, 'r');
headerLine = fgetl(fid);
fclose(fid);
headers = strsplit(strtrim(headerLine), ',');
headers = strrep(headers, '"', ''); % Remove quotes
headers = strrep(headers, ' ', ''); % Remove spaces
headers = matlab.lang.makeValidName(headers); % Make valid MATLAB names

% Assign the cleaned headers to the table
data.Properties.VariableNames = headers;


% --- 2. Create Plot 1: CLift and CDrag vs. Iteration ---
figure; % Create a new figure window

% Use yyaxis to create a plot with two y-axes
yyaxis left; % Activate the left axis
plot(data.Iteration, data.CLift, '-b', 'LineWidth', 2);
xlabel('Iteration');
ylabel('Lift Coefficient (CLift)');
set(gca, 'YColor', 'b'); % Set the left axis color to blue

yyaxis right; % Activate the right axis
plot(data.Iteration, data.CDrag, '-r', 'LineWidth', 2);
ylabel('Drag Coefficient (CDrag)');
set(gca, 'YColor', 'r'); % Set the right axis color to red

% Add title and legend
title('Lift and Drag Coefficient History');
legend('CLift', 'CDrag', 'Location', 'best');
grid on;

% Save the figure
%print('lift_drag_history.png', '-dpng');


% --- 3. Create Plot 2: Residuals vs. Iteration (Semi-log) ---
figure; % Create another new figure window


% Plot each residual on a logarithmic scale
hold on; % Hold the plot to overlay multiple lines

semilogy(data.Iteration, data.Res_Flow_0_, '-r', 'LineWidth', 2)
semilogy(data.Iteration, data.Res_Flow_1_, '-g', 'linewidth', 2)
semilogy(data.Iteration, data.Res_Flow_2_, '-b', 'linewidth', 2)
semilogy(data.Iteration, data.Res_Flow_3_, '-c', 'linewidth', 2)
semilogy(data.Iteration, data.Res_Flow_4_, '-m', 'linewidth', 2)

hold off;

% Set axes properties
set(gca, 'YScale', 'log'); % Ensure y-axis is logarithmic
xlabel('Iteration');
ylabel('Residual Value');
title('Residual Convergence History');
legend(strrep(residualNames, '_', '\_'), 'Location', 'northeast'); % Create legend (escape underscores)
grid on;

% Save the figure
%print('residual_history.png', '-dpng');

% Optional: Close all figure windows
% close all;
