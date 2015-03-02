function Expe_Emotion(subjectname, phase)

%% Game Stuff 
[G, bkg, Clown, Buttonup, Buttondown, gameCommands, Confetti, CircusAnimal] = EmotionGame; 
G.onMouseRelease = @buttondownfcn;

%% Setup experiment 
options.subject_name = subjectname;
options.result_path = '../Results'; 
options.result_prefix = 'emo_';
res_filename = fullfile(options.result_path, sprintf('%s%s.mat', options.result_prefix, options.subject_name));
options.res_filename = res_filename;

results = struct ();
if exist(res_filename, 'file')
    filesList = dir(fullfile(options.result_path, sprintf('*%s*.mat', options.subject_name)));
    options.subject_name = sprintf('%s_%d', options.subject_name, length(filesList)+1);
    res_filename = fullfile(options.result_path, sprintf('%s%s.mat', options.result_prefix, options.subject_name));
    options.res_filename = res_filename;
end
[expe, options] = building_conditions(options);

response_accuracy = [];
starting = 0;   

soundDir = '../Stimuli/Emotion_normalized/';
emotionvoices = classifyFiles(soundDir);
% options = [];

phase = 'test';
options.(phase).total_ntrials

% Add the response to the results structure
% expe.( phase ).condition(itrial) = expe.( phase ).condition(itrial+1);

% ============= Main loop =============   
for itrial = 1 : options.(phase).total_ntrials
    
    while starting == 0
        uiwait();
    end
    
    CircusAnimal.State = 'circusanimal'; 
    Clown.State = 'silent';
    Buttonup.State = 'off';
    Buttondown.State = 'off';
    Confetti.State = 'nono'; 
    
    emotionVect = strcmp({emotionvoices.emotion}, expe.(phase).condition(itrial).voicelabel);
    phaseVect = strcmp({emotionvoices.phase}, phase);
    possibleFiles = [emotionVect & phaseVect];
    indexes = 1:length(possibleFiles);
    indexes = indexes(possibleFiles);
    %this should store all names of possibleFiles 
    toPlay = randperm(length(emotionvoices(indexes)),1);
    
    [y, Fs] = audioread(emotionvoices(indexes(toPlay)).name);
    disp (emotionvoices(indexes(toPlay)).emotion)
    player = audioplayer (y, Fs);
    playblocking (player); 
    
    Clown.State = expe.(phase).condition(itrial).facelabel;
    Buttonup.State = 'on';
    Buttondown.State = 'on';
    
    tic();
    uiwait();
    % remove just played file from list of possible sound files
    emotionvoices(indexes(toPlay)) = [];
    
    resp(itrial).response=response;
    resp(itrial).condition=expe.(phase).condition(itrial);
    
    save ('tryoutresponses.mat', 'resp');
    
    
end

% response_accuracy = [response_accuracy, response.correct]; 
% resp = repmat(struct(response.button_clicked, 0), 1);



%% 
    function buttondownfcn(hObject, callbackdata)
        
        locClick = get(hObject,'CurrentPoint');
        
        if starting == 1
            
            response.timestamp = now();
            response.response_time = toc();
            response.button_clicked = 0; % default in case they click somewhere else
            
            if (locClick(1) >= Buttonup.clickL) && (locClick(1) <= Buttonup.clickR) && ...
                    (locClick(2) >= Buttonup.clickD) && (locClick(2) <= Buttonup.clickU)
                response.button_clicked = 1;
            end
            
            if (locClick(1) >= Buttondown.clickL) && (locClick(1) <= Buttondown.clickR) && ...
                    (locClick(2) >= Buttondown.clickD) && (locClick(2) <= Buttondown.clickU)
                response.button_clicked = 0;
            end
            
            response.correct = (response.button_clicked == expe.(phase).condition(itrial).congruent);
            
            if response.correct 
                Confetti.State = 'confetti';
                pause(1)
            end
            
            fprintf('Clicked button: %d\n', response.button_clicked);
            fprintf('Trials: %d\n', itrial);
            fprintf('Response time : %d ms\n', round(response.response_time*1000));
            fprintf('Response correct: %d\n\n', response.correct);
            
            uiresume
       
        else
             if (locClick(1) >= gameCommands.clickL) && (locClick(1) <= gameCommands.clickR) && ...
                (locClick(2) >= gameCommands.clickD) && (locClick(2) <= gameCommands.clickU)
             starting = 1;
             gameCommands.State = 'empty';
             uiresume();
             end
            
        end
    end

end




     
