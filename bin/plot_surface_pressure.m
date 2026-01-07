% MATLAB script to read surface flow data and plot the pressure distribution.
% This script is designed to replicate the plotting behavior of the provided
% 'plot_pressure.py' Python script.

% --- 1. Setup and Data Loading ---

% The Python script takes the filename as a command-line argument.
% Here, we define it as a variable.
filename = 'surface_flow.csv';

% Read the CSV file into a table.
data = readtable(filename);

% The Python script cleans the column headers by making them lowercase.
% We replicate that here for consistency.
data.Properties.VariableNames = lower(data.Properties.VariableNames);

% The Python script sorts the data by 'global_index'.
data = sortrows(data, 'global_index');


% --- 2. Plotting ---

% Create a new figure
fig = figure;

% --- Left Y-Axis (Pressure Coefficient) ---
% This corresponds to 'ax1' in the Python script.
yyaxis left;

% Plot Pressure_Coefficient vs. x_coord
plot(data.x_coord, data.pressure_coefficient, '-b', 'LineWidth', 2.0);

% Invert the y-axis, as done with 'ax1.set_ylim(ax1.get_ylim()[::-1])'
set(gca, 'YDir', 'reverse');

% Set labels for the axes, using LaTeX interpreter to match Python's r'string'
xlabel('$x/c$', 'FontSize', 20, 'Interpreter', 'latex');
ylabel('$C_p$', 'FontSize', 20, 'Interpreter', 'latex');
% Set the color of the y-axis to match the plot line for clarity
set(gca, 'YColor', 'b');

% --- Right Y-Axis (Airfoil Shape) ---
% This corresponds to 'ax2 = ax1.twinx()' in the Python script.
yyaxis right;

% Plot the airfoil shape (y_coord vs. x_coord)
plot(data.x_coord, data.y_coord, '-k', 'LineWidth', 1.5);

% Set the aspect ratio to be equal, replicating 'ax2.axis('equal')'
axis equal;

% Turn off the right axis visibility (lines, ticks, labels),
% replicating 'ax2.axis('off')'
set(gca, 'Visible', 'off');

% Set the axis limits for the entire plot.
% This replicates 'ax2.set_xlim' and 'ax2.set_ylim'.
xlim([-0.02, 1.02]);
ylim([-0.1, 0.7]);


% --- 3. Save Figure ---

% Save the figure to a PNG file, as done with 'plt.savefig()'
% print(fig, 'pressure_distribution.png', '-dpng');

% Optional: Close the figure window after saving
% close(fig);
