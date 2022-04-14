%% Importar datos
% Script para importar datos desde spreadsheet:
%
%    Workbook: C:\Users\Valentina Andrade\Documents\MATLAB\tareas\tarea1\detrending\datos\Canasta_26032022230914.xlsx
%    Worksheet: Canasta

%% Set up the Import Options and import the data
opts = spreadsheetImportOptions("NumVariables", 4);

% Specify sheet and range
opts.Sheet = "Canasta";
opts.DataRange = "A5:D270";

% Specify column names and types
opts.VariableNames = ["time", "pt", "cu", "pi"];
opts.VariableTypes = ["datetime", "double", "double", "double"];

% Specify variable properties
opts = setvaropts(opts, "time", "InputFormat", "");

% Import the data
data = readtable("C:\Users\Valentina Andrade\Documents\MATLAB\tareas\tarea1\detrending\datos\Canasta_26032022230914.xlsx", opts, "UseExcel", false);


%% Clear temporary variables
clear opts