
function write_array_to_csv(fid, first_column, data_array)
data_array = data_array(:);
l = numel(data_array);
fprintf(fid, '%s, ', first_column);
for i=1:l-1
    fprintf(fid, '%.10f, ', data_array(i));
end
fprintf(fid, '%.10f\n', data_array(end));