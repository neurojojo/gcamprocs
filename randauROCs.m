function randauROCs = randauROCs(rr5summary,gcamp,auROCs_gcamp)

mice = fields(rr5summary);
days = [1:size(rr5summary,2)];

randomizations = 200;

zs = 15; % Number of frames to include before and after the reward for auROCs

for i = 1:numel(mice)
    for j = days
       
        fprintf('Analyzing day %1.0f of mouse %s\n',days(j),mice{i});

        behavior_tmp = rr5summary(days(j)).(mice{i});
        gcamp_tmp = gcamp(days(j)).(mice{i});
        aurocs_tmp = auROCs_gcamp(days(j)).(mice{i});
        
        if ~isempty(gcamp(days(j)).(mice{i}))

            rewarded_entries = rr5summary(days(j)).(mice{i}).rewarded_entries;
            unrewarded_entries = rr5summary(days(j)).(mice{i}).unrewarded_entries;

            frames = size(gcamp(days(j)).(mice{i}).C_raw,2);
            num_rewards = size(rewarded_entries,1);
            num_unrewards = size(unrewarded_entries,1);

            % GENERATE RANDOMIZED VALUES
            %
            auROCrr=[];
            auROCru=[];

            for f = 1:randomizations % Iterations for the randomization

                rand_reward = zs+1+randi(frames-zs*2-1,num_rewards,1);
                rand_unreward = zs+1+randi(frames-zs*2-1,num_unrewards,1);

                r_index_before = fix(rand_reward+linspace(-zs,-1,(zs)));
                r_index_after = fix(rand_reward+linspace(0,zs,(zs-1)));

                u_index_before = fix(rand_unreward+linspace(-zs,-1,(zs)));
                u_index_after = fix(rand_unreward+linspace(0,zs,(zs-1)));


            % auROC analysis on randomized rewarded entry times
                auROCrr(f,:) = mayaauroc(gcamp_tmp.C_raw,r_index_before(:),r_index_after(:));
                auROCru(f,:) = mayaauroc(gcamp_tmp.C_raw,u_index_before(:),u_index_after(:));

            end


            % EXTRACT PARAMETERS FROM RANDOMIZED VALUES
            %

            for m = 1:size(auROCrr,2) % Neurons
                tmp = sort(auROCrr(:,m));
                auROCrr_CI(1,m) = prctile(tmp,5);
                auROCrr_CI(2,m) = prctile(tmp,95);
                [mus(m),sigmas(m)]= normfit(auROCrr_CI(:,m));
                % NOTE: Use auROCr (not the randomized auROC)
                zscores_rr(m) = (aurocs_tmp.rewarded(m)-mus(m))/sigmas(m); 
            end

            for m = 1:size(auROCru,2) % Neurons
                tmp = sort(auROCru(:,m));
                auROCru_CI(1,m) = prctile(tmp,5);
                auROCru_CI(2,m) = prctile(tmp,95);
                [mus(m),sigmas(m)]= normfit(auROCru_CI(:,m));
                % NOTE: Use auROCu (not the randomized auROC)
                zscores_ru(m) = (aurocs_tmp.unrewarded(m)-mus(m))/sigmas(m);
            end


            randauROCs(days(j)).(mice{i}).rewarded.auROC = auROCrr;
            randauROCs(days(j)).(mice{i}).unrewarded.auROC = auROCru;

            randauROCs(days(j)).(mice{i}).rewarded.zscores = zscores_rr;
            randauROCs(days(j)).(mice{i}).unrewarded.zscores = zscores_ru;
        
        end
        
    end
end
