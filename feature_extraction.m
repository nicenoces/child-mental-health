function feat_table = feature_extraction(filename,win_lens)

% Load data
data = load(filename);

% Extract features
feat = assemble_features(data.data,win_lens);
        
% Assign to table with column labels
column_headings = {'ah_startle','av_startle','tiltROM_startle','yawROM_startle','wh_startle','wv_startle',...
                        'ah_pre','av_pre','tiltROM_pre','yawROM_pre','wh_pre','wv_pre',...
                        'ah_post','av_post','tiltROM_post','yawROM_post','wh_post','wv_post'};
feat_table = array2table(feat,'VariableNames',column_headings);

end

function X = assemble_features(data,win_lens)
% Function that defines index arrays to segment data into phases, computes 
% features, and arranges in feature vector
% Expects data and win_lens

% During startle period
ind_per = data.time >= data.tstart - (win_lens.startle/2) & data.time <= data.tstart + (win_lens.startle/2);
ind_per_trunc = ind_per(data.time>=data.ts);
feat_startle = get_features(data,ind_per_trunc);

%Pre-startle
ind_per = data.time >= data.tstart - win_lens.pre_startle & data.time < data.tstart-win_lens.startle;
ind_per_trunc = ind_per(data.time>=data.ts);
feat_pre = get_features(data,ind_per_trunc);

%Post-startle
ind_per = data.time >= data.tstart + win_lens.startle & data.time <= data.tstart + win_lens.post_startle;
ind_per_trunc = ind_per(data.time>=data.ts);
feat_post = get_features(data,ind_per_trunc);

X = [feat_startle, feat_pre, feat_post];
end

function feat = get_features(data,ind_per_trunc)
% Function to compute features during the threat response phase defined by
% ind_per_trunc

% Extract data
a = data.A_lab(ind_per_trunc,:);
w = data.W_lab(ind_per_trunc,:);
tilt = data.tilt(ind_per_trunc);
ant = data.anterior(ind_per_trunc,:);

ant_p = ant - dot((ant(:,1).^0)*[0,0,1],ant,2) * [0,0,1];
ant_pn = [ant_p(:,1)./sqrt(sum(ant_p.^2,2)),...
          ant_p(:,2)./sqrt(sum(ant_p.^2,2)),...
          ant_p(:,3)./sqrt(sum(ant_p.^2,2))];
yaw = real(acosd(dot((ant_pn(:,1).^0)*ant_pn(1,:),ant_pn,2)));

% Calculate features
ah = rms(sqrt(sum(a(:,1:2).^2,2))) * 9.81; %m/s^2
av = rms(a(:,3)) * 9.81; %m/s^2

tiltROM = max(tilt)-min(tilt); %deg
yawROM = max(yaw)-min(yaw); %deg

wh = rms(sqrt(sum(w(:,1:2).^2,2))); %deg/s
wv = rms(w(:,3)); %deg/s

% Assign to feature vector
feat = [ah, av, tiltROM, yawROM, wh, wv];

end