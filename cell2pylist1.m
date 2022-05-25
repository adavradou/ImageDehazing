% We write the names of the input images in a file, in order to be read by
% the python script. 
function cell2pylist1(hazy_images, filename)
hazy_images = permute(hazy_images, ndims(hazy_images):-1:1);
% Get str representationelement
output = '';
for i = 1:numel(hazy_images)
    if isempty(hazy_images{i})
        el = 'None';
    elseif ischar(hazy_images{i}) || isstring(hazy_images{i})
        %el = ['"', char(string(hazy_images{i})), '"'];
        el = [char(string(hazy_images{i}))];
    elseif isa(hazy_images{i}, 'double') && hazy_images{i} ~= int64(hazy_images{i})
        el = sprintf('%.16e', hazy_images{i});
    else
        el = [char(string(hazy_images{i}))];
    end
%     Add to output
    %output = [output, el, ', '];
    output = [output, el, ' '];
end
%output = ['[', output(1:end-1), ']'];
output = [output(1:end-1)];
% Print out
fid = fopen(filename, 'w');
fprintf(fid, '%s\n', output);
fclose(fid);
end