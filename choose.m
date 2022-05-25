function output = choose(file)

fileID = fopen(file);
C = textscan(fileID,'%s %s');
fclose(fileID);

data = [C{1,1} C{1,2}];
disp(data);

output = input('');