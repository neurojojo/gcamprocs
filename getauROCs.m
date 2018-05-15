function auROCs_gcamp = getauROCs(rr5summary,gcamp)

mice = fields(rr5summary);
days = [1:size(rr5summary,2)];

zs = 15; % Number of frames to include before and after the reward for auROCs

% Make sure mapping between gcamp and rewards is correct

for i = 1:numel(mice)
    for j = days
        
        fprintf('Analyzing day %1.0f of mouse %s\n',days(j),mice{i});
        
        behavior_tmp = rr5summary(days(j)).(mice{i});
        
        if ~isempty(gcamp(days(j)).(mice{i}));
        
            gcamp_tmp = gcamp(days(j)).(mice{i});

            % Creates a matrix with all before and after intervals to be used
            % in auROC function 
            %
            % EXAMPLE:
            % [reward1_time,reward1_time+1,reward1_time+2,reward1_time+n,...reward1_time+zs]
            % [reward2_time,reward2_time+1,reward2_time+2,reward2_time+n,...reward2_time+zs]
            %

            % Checking for frames that exceed the dimensions of the gcamp
            % traces (rewards were too late)
            frames = size(gcamp_tmp.C_raw,2);
            behavior_tmp.rewarded_entries(behavior_tmp.rewarded_entries>frames-zs)=[];
            behavior_tmp.unrewarded_entries(behavior_tmp.unrewarded_entries>frames-zs)=[];

            % Checking for frames that precede the start of the analysis window
            % traces (rewards were too early)
            behavior_tmp.rewarded_entries(behavior_tmp.rewarded_entries<zs)=[];
            behavior_tmp.unrewarded_entries(behavior_tmp.unrewarded_entries<zs)=[];

            % Returning indices
            r_index_before = fix(behavior_tmp.rewarded_entries+linspace(-zs,-1,(zs)));
            r_index_after = fix(behavior_tmp.rewarded_entries+linspace(0,zs,(zs-1)));

            u_index_before = fix(behavior_tmp.unrewarded_entries+linspace(-zs,-1,(zs)));
            u_index_after = fix(behavior_tmp.unrewarded_entries+linspace(0,zs,(zs-1)));

            auROCr = [];
            auROCr = mayaauroc(gcamp_tmp.C_raw,r_index_before(:),r_index_after(:));

            auROCu = [];
            auROCu = mayaauroc(gcamp_tmp.C_raw,u_index_before(:),u_index_after(:));

            auROCs_gcamp(day(j)).(mice{i}).rewarded = auROCr;
            auROCs_gcamp(day(j)).(mice{i}).unrewarded = auROCu;
        
        end
        
    end
end


