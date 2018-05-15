set(0,'DefaultFigureColor','w');
set(0,'DefaultLineLineWidth',4);

clearvars dist* numcells*
dist_from_CI = auROCdistances(auROCs_gcamp,randauROCs_gcamp);

mice = fields(dist_from_CI);
days = [1:size(rr5summary,2)];

for i = 1:numel(mice)
    for j = days
       
        if ~isempty(dist_from_CI(days(j)).(mice{i}))
            dist_r_below(i,j) = sum(abs(dist_from_CI(days(j)).(mice{i}).rewarded.below))/numel(dist_from_CI(days(j)).(mice{i}).rewarded.below);
            dist_r_above(i,j) = sum(abs(dist_from_CI(days(j)).(mice{i}).rewarded.above))/numel(dist_from_CI(days(j)).(mice{i}).rewarded.above);

            dist_u_below(i,j) = sum(abs(dist_from_CI(days(j)).(mice{i}).unrewarded.below))/numel(dist_from_CI(days(j)).(mice{i}).unrewarded.below);
            dist_u_above(i,j) = sum(abs(dist_from_CI(days(j)).(mice{i}).unrewarded.above))/numel(dist_from_CI(days(j)).(mice{i}).unrewarded.above);

            numcells_r_below(i,j) = numel(dist_from_CI(days(j)).(mice{i}).rewarded.below)/size(gcamp(days(j)).(mice{i}).C_raw,1);
            numcells_r_above(i,j) = numel(dist_from_CI(days(j)).(mice{i}).rewarded.above)/size(gcamp(days(j)).(mice{i}).C_raw,1);

            numcells_u_below(i,j) = numel(dist_from_CI(days(j)).(mice{i}).unrewarded.below)/size(gcamp(days(j)).(mice{i}).C_raw,1);
            numcells_u_above(i,j) = numel(dist_from_CI(days(j)).(mice{i}).unrewarded.above)/size(gcamp(days(j)).(mice{i}).C_raw,1);
        end
        
    end
end

%
d2 = {'m7674','m8265','m7675','m8170'};
ctrl = {'m7677','m8268'};
colors = jet(200);

for i = 1:numel(mice); 
    
    % D2s are colored blue (Ctrl are red)
    if ~isempty(cell2mat(strfind(d2,mice{i}))); colorcode = 1; else; colorcode = 200; end
    figure(1); 
    
    subplot(2,2,1); plot(dist_r_below(i,:),'color',colors(colorcode,:)); hold on;  ylim([0,.1]); title('Dist r below');
    subplot(2,2,2); plot(dist_r_above(i,:),'color',colors(colorcode,:)); hold on;  ylim([0,.1]); title('Dist r above'); 
    subplot(2,2,3); plot(dist_u_below(i,:),'color',colors(colorcode,:)); hold on;  ylim([0,.1]); title('Dist ur below');
    subplot(2,2,4); plot(dist_u_above(i,:),'color',colors(colorcode,:)); hold on;  ylim([0,.1]); title('Dist ur above');

    figure(2); 

    subplot(2,2,1); plot(numcells_r_below(i,:),'color',colors(colorcode,:)); hold on;  ylim([0,1]); title('Num r below');
    subplot(2,2,2); plot(numcells_r_above(i,:),'color',colors(colorcode,:)); hold on;  ylim([0,1]); title('Num r above');
    subplot(2,2,3); plot(numcells_u_below(i,:),'color',colors(colorcode,:)); hold on;  ylim([0,1]); title('Num ur below');
    subplot(2,2,4); plot(numcells_u_above(i,:),'color',colors(colorcode,:)); hold on;  ylim([0,1]); title('Num ur above');

end

[d2ctrl]=[0,1,1,1,1,0]
colorcode = [1,200];

for i = 0:1
figure(3);
subplot(2,2,1); plot(nanmean(dist_r_below(find(d2ctrl==i),:),1),'color',colors(colorcode(i+1),:)); hold on;  ylim([0,.1]); title('Dist r below');
subplot(2,2,2); plot(nanmean(dist_r_above(find(d2ctrl==i),:),1),'color',colors(colorcode(i+1),:)); hold on;  ylim([0,.1]); title('Dist r above'); 
subplot(2,2,3); plot(nanmean(dist_u_below(find(d2ctrl==i),:),1),'color',colors(colorcode(i+1),:)); hold on;  ylim([0,.1]); title('Dist ur below');
subplot(2,2,4); plot(nanmean(dist_u_above(find(d2ctrl==i),:),1),'color',colors(colorcode(i+1),:)); hold on;  ylim([0,.1]); title('Dist ur above');

figure(4);
subplot(2,2,1); plot(nanmean(numcells_r_below(find(d2ctrl==i),:),1),'color',colors(colorcode(i+1),:)); hold on;  ylim([0,1]); title('Num r below');
subplot(2,2,2); plot(nanmean(numcells_r_above(find(d2ctrl==i),:),1),'color',colors(colorcode(i+1),:)); hold on;  ylim([0,1]); title('Num r above'); 
subplot(2,2,3); plot(nanmean(numcells_u_below(find(d2ctrl==i),:),1),'color',colors(colorcode(i+1),:)); hold on;  ylim([0,1]); title('Num ur below');
subplot(2,2,4); plot(nanmean(numcells_u_above(find(d2ctrl==i),:),1),'color',colors(colorcode(i+1),:)); hold on;  ylim([0,1]); title('Num ur above');

end

%
figure(5);
for i = 1:numel(mice)
    for j = 1:5
        
        if ~isempty(auROCs_gcamp(j).(mice{i}))
            [y,x] = ecdf(auROCs_gcamp(j).(mice{i}).rewarded);
            subplot(2,5,j); plot(x,y,'color',colors(1+d2ctrl(i)*199,:),'linewidth',3); hold on; title(j);
            if (j==1); subplot(2,5,1); ylabel('Rewarded'); end
            [y,x] = ecdf(auROCs_gcamp(j).(mice{i}).unrewarded);
            subplot(2,5,j+5); plot(x,y,'color',colors(1+d2ctrl(i)*199,:),'linewidth',3); hold on; title(j);
            if (j+5==6); subplot(2,5,6); ylabel('Unrewarded'); end
        end
        
    end
end

%

figure(6);
for i = 1:numel(mice)
    for j = 1:5
        
        if ~isempty(auROCs_gcamp(j).(mice{i}))
            data = (auROCs_gcamp(j).(mice{i}).rewarded);
            subplot(2,5,j); plot(sort(data),'color',colors(1+d2ctrl(i)*199,:),'linewidth',3); hold on; title(j);
            if (j==1); subplot(2,5,1); ylabel('Rewarded'); end
            data = (auROCs_gcamp(j).(mice{i}).unrewarded);
            subplot(2,5,j+5); plot(sort(data),'color',colors(1+d2ctrl(i)*199,:),'linewidth',3); hold on; title(j);
            if (j+5==6); subplot(2,5,6); ylabel('Unrewarded'); end
        end
        
    end
end

%

figure(7);
for i = 1:numel(mice)
    for j = 1:5
        prctile(randauROCs_gcamp(1).(mice{i}).rewarded.auROC,95)
    end
end


%%
figure; 
subplot(2,2,1);
plot(numcells_u_above')
title('Numcells above unrewarded')
ylim([0,1])
subplot(2,2,2); plot(numcells_u_below')
title('Numcells below unrewarded')
ylim([0,1])


subplot(2,2,3);
plot(numcells_r_above')
title('Numcells above rewarded')
ylim([0,1])
subplot(2,2,4); plot(numcells_r_below')
title('Numcells below rewarded')