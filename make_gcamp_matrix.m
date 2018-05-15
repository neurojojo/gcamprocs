%% Summarizes data from many neuron structures with gcamp data
%
% Given that your filenames are in the format:
% 
% "Workspace <mouse#> RR5 Day<#> calculated.mat"
%
% For example:
% Workspace m7677 RR5 Day1 calculated.mat
%
% This will loop over a cell array containing the mouse names
% mouse = {'2434','343',...etc}
%
% Next, will load all workspaces with that name (for 5 days)
% The resulting structure gcamp will have the neuron gcamp traces
% along with images of where the neurons are located
% 
% The calcium traces:           gcamp(day#).(mouseid).neuron
% The images of the neurons:    gcamp(day#).(mouseid).neu_image
%

mouse={'7674','7675','7677','8170','8265','8268'};

mydir = 'D:/troels gcamp/Workspaces';

for i = 1:numel(mouse)
    files = {};
    files{1} = sprintf('%s/Workspace %s RR5 Day1 calculated.mat',mydir,mouse{i});
    files{2} = sprintf('%s/Workspace %s RR5 Day2 calculated.mat',mydir,mouse{i});
    if strcmp(mouse{i},'8268')
    else
        files{3} = sprintf('%s/Workspace %s RR5 Day3 calculated.mat',mydir,mouse{i});
        files{4} = sprintf('%s/Workspace %s RR5 Day4 calculated.mat',mydir,mouse{i});
        if strcmp(mouse{i},'7677');
            files{5} = sprintf('%s/Workspace %s RR5 Day5 original.mat',mydir,mouse{i});
        else
            files{5} = sprintf('%s/Workspace %s RR5 Day5 calculated.mat',mydir,mouse{i});
        end
    end
    
for day = 1:size(files,2)
            
    load(files{day});
    tmp_Craw = neuron.C_raw;
    tmp_neu_image = zeros(size(neuron.A,1)^(1/2),size(neuron.A,1)^(1/2),size(neuron.A,2));
    
    for j = 1:size(neuron.A,2)
        tmp_neu_image(:,:,j) = reshape(neuron.A(:,j),[size(neuron.A,1)^(1/2),size(neuron.A,1)^(1/2)]);
    end
    
    evalin('base',sprintf('gcamp(%1.0f).m%s.%s=%s;',day,mouse{i},'C_raw','tmp_Craw'));
    evalin('base',sprintf('gcamp(%1.0f).m%s.%s=%s;',day,mouse{i},'A','tmp_neu_image'));
    evalin('base',sprintf('gcamp(%1.0f).m%s.%s=%s;',day,mouse{i},'center','center'));
    
end

end

%% After running this, can (if you don't need any variables)
% Clear all of what you had before

clearvars -except gcamp rr5data rr5summary animals days

