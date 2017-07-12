%% Child Anxiety Feature Extraction Main Script   
% This script provides an example implementations of functions to extract 
% measures of child movement during three theorized temporal threat response 
% phases.  
% Written by Ryan S. McGinnis - ryan.mcginnis@uvm.edu - July 12, 2017

% Copyright (C) 2017  Ryan S. McGinnis

%% Script for extracting features of data from example subject
filename = 'example_data.mat';
win_lens.startle = 6; %length of startle phase
win_lens.pre_startle = 20; %length of the potential threat phase
win_lens.post_startle = 20; %length of the response modulation phase
feat_table = feature_extraction(filename,win_lens);
disp(feat_table)
