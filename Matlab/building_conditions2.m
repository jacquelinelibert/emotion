<<<<<<< HEAD
function [expe, options] = building_conditions2 (options)

%----------- Design specification
options.test.n_repeat = 8; % Number of repetition per condition
options.test.retry = 1; % Number of retry if measure failed
options.test.total_ntrials = 72; % nr of trials per block 

options.facerecognition.n_repeat = 2;
options.facerecognition.retry = 0 ; 
options.facerecognition.total_ntrials = 6; % nr of trials of training1

options.training.n_repeat = 0;  
options.training.retry = 0; 
options.training.total_ntrials = 72; % nr of trials of training2

%  training1 
%  6 faces are presented without sounds. Each face is presented twice. 

% -------- Stimuli options 
options.facerecognition.faces = {'angry', 'sad', 'joyful','angry', 'sad', 'joyful'};

%---
options.test.voices = {'angry', 'sad', 'joyful'};
options.test.faces = {'angry', 'sad', 'joyful'};


%--- stimuli pairs
% [voice, face]
options.test.stimuli_pairs = [...
    1 1;  % angry - angry
    1 2;  % angry - sad
    1 3;  % angry - joyful
    2 1;  % sad - angry
    2 2;  % sad - sad
    2 3;  % sad - joyful
    3 1;  % joyful - angry
    3 2;  % joyful - sad
    3 3;];  % joyful - joyful

%==================================================== Build test block

itrial = 0;
for ir = 1:options.test.n_repeat
    for i_sp = 1:size(options.test.stimuli_pairs, 1)
        itrial = itrial + 1;
        condition(itrial).voice = options.test.stimuli_pairs(i_sp, 1);
        condition(itrial).face = options.test.stimuli_pairs(i_sp, 2);           
        condition(itrial).voicelabel = options.test.voices{options.test.stimuli_pairs(i_sp, 1)};
        condition(itrial).facelabel = options.test.faces{options.test.stimuli_pairs(i_sp, 2)};           
        condition(itrial).congruent = condition(itrial).voice == condition(itrial).face;
                
    end
end

% Add something so that every condition is picked an equal nr of times? 

% Randomization of the order
%options.n_blocks = length(test.conditions)/options.test.block_size;
test.condition = condition(randperm(length(condition)));
training.condition = condition(randperm(9));

options.facerecognition.faces = options.facerecognition.faces(randperm(length(options.facerecognition.faces)));
%====================================== Create the expe structure and save

expe.test = test;
expe.training = training;
expe.facerecognition = options.facerecognition;

%--
                
if isfield(options, 'res_filename')
    save(options.res_filename, 'options', 'expe');
else
    warning('The test file was not saved: no filename provided.');
end
=======
function [expe, options] = building_conditions2 (options)

%----------- Design specification
options.test.n_repeat = 8; % Number of repetition per condition
options.test.retry = 1; % Number of retry if measure failed
options.test.total_ntrials = 72; % nr of trials per block 

options.facerecognition.n_repeat = 2;
options.facerecognition.retry = 0 ; 
options.facerecognition.total_ntrials = 6; % nr of trials of training1

options.training.n_repeat = 0;  
options.training.retry = 0; 
options.training.total_ntrials = 72; % nr of trials of training2

%  training1 
%  6 faces are presented without sounds. Each face is presented twice. 

% -------- Stimuli options 
options.facerecognition.faces = {'angry', 'sad', 'joyful','angry', 'sad', 'joyful'};

%---
options.test.voices = {'angry', 'sad', 'joyful'};
options.test.faces = {'angry', 'sad', 'joyful'};


%--- stimuli pairs
% [voice, face]
options.test.stimuli_pairs = [...
    1 1;  % angry - angry
    1 2;  % angry - sad
    1 3;  % angry - joyful
    2 1;  % sad - angry
    2 2;  % sad - sad
    2 3;  % sad - joyful
    3 1;  % joyful - angry
    3 2;  % joyful - sad
    3 3;];  % joyful - joyful

%==================================================== Build test block

itrial = 0;
for ir = 1:options.test.n_repeat
    for i_sp = 1:size(options.test.stimuli_pairs, 1)
        itrial = itrial + 1;
        condition(itrial).voice = options.test.stimuli_pairs(i_sp, 1);
        condition(itrial).face = options.test.stimuli_pairs(i_sp, 2);           
        condition(itrial).voicelabel = options.test.voices{options.test.stimuli_pairs(i_sp, 1)};
        condition(itrial).facelabel = options.test.faces{options.test.stimuli_pairs(i_sp, 2)};           
        condition(itrial).congruent = condition(itrial).voice == condition(itrial).face;
                

    end
end

% Add something so that every condition is picked an equal nr of times? 

% Randomization of the order
%options.n_blocks = length(test.conditions)/options.test.block_size;
test.condition = condition(randperm(length(condition)));
training.condition = condition(randperm(9));

options.facerecognition.faces = options.facerecognition.faces(randperm(length(options.facerecognition.faces)));
%====================================== Create the expe structure and save

expe.test = test;
expe.training = training;
expe.facerecognition = options.facerecognition;

%--
                
if isfield(options, 'res_filename')
    save(options.res_filename, 'options', 'expe');
else
    warning('The test file was not saved: no filename provided.');
end
>>>>>>> 2f13273f84154e0fe5f581382b5f751412c581b3
