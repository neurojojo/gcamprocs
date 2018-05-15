function dist_from_CI = auROCdistances(auROCs_gcamp,randauROCs_gcamp)

mice = fields(auROCs_gcamp);
days = [1:size(auROCs_gcamp,2)];

for i = 1:numel(mice)
    for j = days
        

        if ~isempty(auROCs_gcamp(days(j)).(mice{i}))
            fprintf('Analyzing day %1.0f of mouse %s\n',days(j),mice{i});

            auROCs_tmp = auROCs_gcamp(days(j)).(mice{i}).rewarded;
            randauROCs_tmp = randauROCs_gcamp(days(j)).(mice{i}).rewarded.auROC;

            distances=[prctile(randauROCs_tmp,5)',prctile(randauROCs_tmp,95)']-[auROCs_tmp'];

            below_ci_r = find(auROCs_tmp<prctile(randauROCs_tmp,5));
            inside_ci_r = find((auROCs_tmp>prctile(randauROCs_tmp,5) & auROCs_tmp<prctile(randauROCs_tmp,95))==1);
            above_ci_r = find(auROCs_tmp>prctile(randauROCs_tmp,95));
            
            auROCs_tmp = auROCs_gcamp(days(j)).(mice{i}).unrewarded;
            randauROCs_tmp = randauROCs_gcamp(days(j)).(mice{i}).unrewarded.auROC;

            distances=[prctile(randauROCs_tmp,5)',prctile(randauROCs_tmp,95)']-[auROCs_tmp'];

            below_ci_u = find(auROCs_tmp<prctile(randauROCs_tmp,5));
            inside_ci_u = find((auROCs_tmp>prctile(randauROCs_tmp,5) & auROCs_tmp<prctile(randauROCs_tmp,95))==1);
            above_ci_u = find(auROCs_tmp>prctile(randauROCs_tmp,95));
            
        
            dist_from_CI(day(j)).(mice{i}).rewarded.below = -distances(below_ci_r,1); 
            dist_from_CI(day(j)).(mice{i}).rewarded.above = -distances(above_ci_r,2);

            dist_from_CI(day(j)).(mice{i}).unrewarded.below = -distances(below_ci_u,1); 
            dist_from_CI(day(j)).(mice{i}).unrewarded.above = -distances(above_ci_u,2);

            
        end
        
    end
end
