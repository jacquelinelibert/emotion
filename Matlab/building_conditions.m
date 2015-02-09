function [expe, options] = building_conditions(options)

%----------- Signal options
options.fs = 44100;
if test_machine
    options.attenuation_dB = 3;  % General attenuation
else
    options.attenuation_dB = 27; % General attenuation
end
options.ear = 'both'; % right, left or both

% test_machine = is_test_machine();

%----------- Design specification
options.test.n_repeat = 8; % Number of repetition per condition
options.test.retry = 1; % Number of retry if measure failed
options.test.total_ntrials = 72; % nr of trials per block 

options.training1.n_repeat = 2;
options.training1.retry = 0 ; 
options.training1.total_ntrials = 6; % nr of trials of training1

options.training2.n_repeat = 0;  
options.training2.retry = 0; 
options.training2.total_ntrials = 9; 

% -------- Stimuli options 
% options = struct();

% --- training1 
% 6 faces are presented without sounds. Each face is presented twice. 
options.training1.faces = ['angryface', 'sadface', 'joyfulface'];

options.training1.faces(1).label = 'angry'; 

options.training1.face(2).label = 'sad';
options.training1.face(2).face = 'sadface'; 

options.training1.face(3).label = 'joyful';
options.training1.condition(3).face = 'joyfulface'; 

% ------- 
options.test.voice = ['angryvoice', 'sadvoice', 'joyfulvoice'];
options.test.face = ['angryface', 'sadface', 'joyfulface'];
options.test.state = ['congruent', 'incongruent'];

options.test.condition(1).label = 'angry_angry';
options.test.condition(1).voice = 'angryvoice';
options.test.condition(1).face = 'angryface';
options.test.condition(1).state = 'congruent';

options.test.condition(2).label = 'angry_sad';
options.test.condition(2).voice = 'angryvoice';
options.test.condition(2).face = 'sadface';
options.test.condition(2).state = 'incongruent';

options.test.condition(3).label = 'angry_joyful';
options.test.condition(3).voice = 'angryvoice';
options.test.condition(3).face = 'joyfulface';
options.test.condition(3).state = 'incongruent';

options.test.condition(4).label = 'sad_sad';
options.test.condition(4).voice = 'sadvoice';
options.test.condition(4).face = 'sadface';
options.test.condition(4).state = 'congruent';

options.test.condition(5).label = 'sad_angry';
options.test.condition(5).voice = 'sadvoice';
options.test.condition(5).face = 'angryface';
options.test.condition(5).state = 'incongruent';

options.test.condition(6).label = 'sad_joyful';
options.test.condition(6).voice = 'sadvoice';
options.test.condition(6).face = 'joyfulface';
options.test.condition(6).state = 'incongruent';

options.test.condition(7).label = 'joyful_joyful'; 
options.test.condition(7).voice = 'joyfulvoice';
options.test.condition(7).face = 'joyfulface';
options.test.condition(7).state = 'congruent';

options.test.condition(8).label = 'joyful_angry'; 
options.test.condition(8).voice = 'joyfulvoice';
options.test.condition(8).face = 'angryface';
options.test.condition(8).state = 'incongruent';

options.test.condition(9).label = 'joyful_sad'; 
options.test.condition(9).voice = 'joyfulvoice';
options.test.condition(9).face = 'sadface';
options.test.condition(9).state = 'incongruent';

options.training2.condition = options.test.condition;


%==================================================== Build test block

test = struct();

for ir = 1:options.test.n_repeat

        condition = struct();

        condition.vocoder = 0;

        condition.visual_feedback = 1;

        % Do not remove these lines
        condition.i_repeat = ir;
        condition.done = 0;
        condition.attempts = 0;

        if ~isfield(test,'conditions')
            test.conditions = orderfields(condition);
        else
            test.conditions(end+1) = orderfields(condition);
        end
        
end


% Randomization of the order
%options.n_blocks = length(test.conditions)/options.test.block_size;
test.conditions = test.conditions(randperm(length(test.conditions)));

%================================================== Build training1 block

training1 = struct();

for ir = 1:options.training1.n_repeat
    
        condition = struct();
        
        condition.vocoder = 0;

        condition.visual_feedback = 0;

        % Do not remove these lines
        condition.i_repeat = ir;
        condition.done = 0;
        condition.attempts = 0;

        if ~isfield(training1,'conditions')
            training1.conditions = orderfields(condition);
        else
            training1.conditions(end+1) = orderfields(condition);
        end

    end
end

%================================================== Build training2 block

training2 = struct();

for ir = 1:options.training2.n_repeat

        condition = struct();      

        condition.vocoder = 0;

        condition.visual_feedback = 1;

        % Do not remove these lines
        condition.i_repeat = ir;
        condition.done = 0;
        condition.attempts = 0;

        if ~isfield(training2,'conditions')
            training2.conditions = orderfields(condition);
        else
            training2.conditions(end+1) = orderfields(condition);
        end

    end
    end

%====================================== Create the expe structure and save

expe.test = test;
expe.training1 = training1;
expe.training2 = training2; 

%--
                
if isfield(options, 'res_filename')
    save(options.res_filename, 'options', 'expe');
else
    warning('The test file was not saved: no filename provided.');
end
