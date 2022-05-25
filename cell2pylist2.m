function cell2pylist2(clear_images, filename)
clear_images = permute(clear_images, ndims(clear_images):-1:1);
% Get str representationelement
output = '';
for i = 1:numel(clear_images)
    if isempty(clear_images{i})
        el = 'None';
    elseif ischar(clear_images{i}) || isstring(clear_images{i})
        %el = ['"', char(string(clear_images{i})), '"'];
        el = [char(string(clear_images{i}))];
    elseif isa(clear_images{i}, 'double') && clear_images{i} ~= int64(clear_images{i})
        el = sprintf('%.16e', clear_images{i});
    else
        el = [char(string(clear_images{i}))];
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