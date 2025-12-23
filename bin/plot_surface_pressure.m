% Read the CSV data into a MATLAB table
data = readtable('surface_flow.csv');

% --- Data Cleaning ---

% Get the current variable (column) names
original_vars = data.Properties.VariableNames;

% Clean the names: remove extra spaces and quotation marks
% 'strtrim' removes leading/trailing whitespace
% 'strrep' removes the quotation marks
cleaned_vars = strrep(strtrim(original_vars), '"', '');

% Assign the new, clean names back to the table
data.Properties.VariableNames = cleaned_vars;

% --- Sorting ---

% Sort the table by the 'Global_Index' column
% The 'ascend' option is default but included for clarity
sorted_data = sortrows(data, 'Global_Index', 'ascend');

% --- Display Cleaned and Sorted Data (Optional) ---
disp('Cleaned and Sorted Data Head:')
disp(head(sorted_data));

% Now 'sorted_data' is ready for plotting, just like in the Python script.
