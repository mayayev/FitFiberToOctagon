function points = get_data(filename)

textfiledata = fileread(filename);
textfiledata = string(textfiledata);
textfiledata = splitlines(textfiledata);
% nrows_f = contains(textfiledata, 'Num Scan Lines');
% nrows = extractAfter(textfiledata(nrows_f), 'Num Scan Lines,');
% nrows = str2double(nrows);
% ncolumns_f = contains(textfiledata, 'Num Points per Line');
% ncolumns = extractAfter(textfiledata(ncolumns_f), 'Num Points per Line,');
% ncolumns = str2double(ncolumns);
% first_column = 3;
% first_row = 57;


nrows_f = contains(textfiledata, 'NumberOfRows');
nrows = extractAfter(textfiledata(nrows_f), 'NumberOfRows,');
nrows = str2double(nrows);
ncolumns_f = contains(textfiledata, 'NumberOfColumns');
ncolumns = extractAfter(textfiledata(ncolumns_f), 'NumberOfColumns,');
ncolumns = str2double(ncolumns);
first_column = 2;
first_row = 11;
data = csvread(filename, first_row, first_column, [first_row, first_column, first_row+nrows-1, first_column+ncolumns-1]); 

x = -ncolumns/2+1:ncolumns/2;
y = -nrows/2+1:nrows/2;

a = ischange(data);
b = find(a);
[i,j] = ind2sub(size(data), b);
x_edge = x(i);
y_edge = y(j);
points = [x_edge; y_edge];
points = points';

