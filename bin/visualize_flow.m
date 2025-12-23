% MATLAB script to read a legacy VTK file and visualize multiple unstructured grid datasets.

% --- Configuration ---
vtk_filename = 'flow.vtk.txt';

% --- File Parsing ---
fprintf('Opening VTK file: %s\n', vtk_filename);
fid = fopen(vtk_filename, 'r');
if fid == -1
    error('Cannot open the file. Make sure it is in the correct path.');
end

% Initialize variables
num_points = 0;
num_cells = 0;
points = [];
connectivity = [];
pressure_scalars = [];
mach_scalars = [];

% Read the file line-by-line to find all required data blocks
while ~feof(fid)
    line = fgetl(fid);

    % Find and read the POINTS data block
    if contains(line, 'POINTS')
        num_points = sscanf(line, 'POINTS %d float');
        fprintf('Reading %d points...\n', num_points);
        points = fscanf(fid, '%f', [3, num_points])';
    end

    % Find and read the CELLS data block (connectivity)
    if contains(line, 'CELLS')
        info = sscanf(line, 'CELLS %d %d');
        num_cells = info(1);
        fprintf('Reading %d cells...\n', num_cells);
        cell_data = fscanf(fid, '%d', [4, num_cells])';
        connectivity = cell_data(:, 2:4) + 1; % Convert to 1-based indexing
    end
    
    % Find and read the SCALARS data for Pressure_Coefficient
    if contains(line, 'SCALARS Pressure_Coefficient')
        fprintf('Reading Pressure_Coefficient scalars...\n');
        fgetl(fid); % Skip the 'LOOKUP_TABLE' line
        pressure_scalars = fscanf(fid, '%f', [1, num_points])';
    end

    % Find and read the SCALARS data for Mach
    if contains(line, 'SCALARS Mach')
        fprintf('Reading Mach_number scalars...\n');
        fgetl(fid); % Skip the 'LOOKUP_TABLE' line
        mach_scalars = fscanf(fid, '%f', [1, num_points])';
    end
end
fclose(fid);
fprintf('Finished reading data.\n');

% --- Visualization ---
if isempty(points) || isempty(connectivity)
    error('Failed to parse geometry (POINTS or CELLS) from the VTK file.');
end

% Figure 1: Plot the Wireframe Mesh
figure('Name', 'Airfoil Mesh', 'NumberTitle', 'off');
patch('Faces', connectivity, 'Vertices', points, 'FaceColor', 'none', 'EdgeColor', [0.2 0.2 0.2]);
title('Wireframe Mesh');
xlabel('X Coordinate');
ylabel('Y Coordinate');
axis equal;
grid on;
view(2);
disp('Generated wireframe mesh plot.');

% Figure 2: Plot the Filled Contour of Pressure Coefficient
if ~isempty(pressure_scalars)
    figure('Name', 'Pressure Coefficient Contour', 'NumberTitle', 'off');
    patch('Faces', connectivity, 'Vertices', points, ...
          'FaceVertexCData', pressure_scalars, 'FaceColor', 'interp', 'EdgeColor', 'none');
    title('Pressure Coefficient (Cp)');
    xlabel('X Coordinate');
    ylabel('Y Coordinate');
    axis equal;
    view(2);
    colorbar;
    disp('Generated pressure contour plot.');
else
    warning('Pressure_Coefficient data not found in the file.');
end

% Figure 3: Plot the Filled Contour of Mach Number
if ~isempty(mach_scalars)
    figure('Name', 'Mach Number Contour', 'NumberTitle', 'off');
    patch('Faces', connectivity, 'Vertices', points, ...
          'FaceVertexCData', mach_scalars, 'FaceColor', 'interp', 'EdgeColor', 'none');
    title('Mach Number');
    xlabel('X Coordinate');
    ylabel('Y Coordinate');
    axis equal;
    view(2);
    colorbar;
    disp('Generated Mach number contour plot.');
else
    warning('Mach_number data not found in the file.');
end
