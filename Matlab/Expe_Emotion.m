function Expe_Emotion(subjectname, phase)
% 

    added_path  = {};

    added_path{end+1} = 'C:/Users/Jacqueline Libert/Documents/SpriteKit';
    

    for i=1:length(added_path)
        addpath(added_path{i});
    end

    %% Game Stuff 
    [G, bkg, Clown, Buttonup, Buttondown, gameCommands, Confetti, CircusAnimal, Parrot] = EmotionGame; 
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

    % Add the response to the results structure
    % expe.( phase ).condition(itrial) = expe.( phase ).condition(itrial+1);

    %% ============= Main loop =============   
    for itrial = 1 : options.(phase).total_ntrials 
        
        while starting == 0
            uiwait();
        end
        
        CircusAnimal.State =sprintf ('circusanimal_%d', ceil(itrial/6));
        CircusAnimal.Location = [CircusAnimal.currentLocation{itrial}];
        
        if itrial == 1
            Clown.State = 'joyful'; 
        end
        
        Buttonup.State = 'off';
        Buttondown.State = 'off';
        Confetti.State = 'off'; 
        Parrot.State = 'neutral';
        pause(1);
        
        for j = 5:-1:1
            Clown.State = sprintf('clown_%d',j);
            pause(0.05)
        end
       
        emotionVect = strcmp({emotionvoices.emotion}, expe.(phase).condition(itrial).voicelabel);
        phaseVect = strcmp({emotionvoices.phase}, phase);
        possibleFiles = [emotionVect & phaseVect];
        indexes = 1:length(possibleFiles);
        indexes = indexes(possibleFiles);
        
        if isempty(emotionvoices(indexes)) % extend structure with missing files and redo selection
            nLeft = length(emotionvoices);
            tmp = emotionvoices(strcmp({emotionvoices.phase}, phase));
            emotionvoices(nLeft + 1 : nLeft + length(tmp)) = tmp;
            clear tmp
            emotionVect = strcmp({emotionvoices.emotion}, expe.(phase).condition(itrial).voicelabel);
            phaseVect = strcmp({emotionvoices.phase}, phase);
            possibleFiles = [emotionVect & phaseVect];
            indexes = 1:length(possibleFiles);
            indexes = indexes(possibleFiles);
        end
    
        %this should store all names of possibleFiles 
        toPlay = randperm(length(emotionvoices(indexes)),1);
        [y, Fs] = audioread(emotionvoices(indexes(toPlay)).name);
        disp (emotionvoices(indexes(toPlay)).emotion)
        player = audioplayer (y, Fs);
        iter = 1;
        play(player)
        while true
            Parrot.State = ['parrot_' sprintf('%i', mod(iter, 2) + 1)];
            iter = iter + 1;
            pause(0.02);
            if ~isplaying(player)
                Parrot.State = 'neutral';
                break;
            end
        end
        
        for i = 1:5
            Clown.State = sprintf('clown_%d',i);
            pause(0.05)
        end
        
        
        Clown.State = expe.(phase).condition(itrial).facelabel;
        Buttonup.State = 'on';
        Buttondown.State = 'on';

        tic();
        uiwait();
        % remove just played file from list of possible sound files
        emotionvoices(indexes(toPlay)) = [];

        resp(itrial).response = response;
        resp(itrial).condition = expe.(phase).condition(itrial);
        
        save (options.res_filename, 'options', 'expe', 'resp');
        
        
        if itrial == options.(phase).total_ntrials
            gameCommands.Scale = 2; 
            gameCommands.State = 'finish';
        end
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
                Buttonup.State = 'press';
                response.button_clicked = 1;
            end
            
            if (locClick(1) >= Buttondown.clickL) && (locClick(1) <= Buttondown.clickR) && ...
                    (locClick(2) >= Buttondown.clickD) && (locClick(2) <= Buttondown.clickU)
                Buttondown.State = 'press'; 
                response.button_clicked = 0;
            end
            
            pause(0.5)
            
            response.correct = (response.button_clicked == expe.(phase).condition(itrial).congruent);
            
            if response.correct 
                for k = 1:7
                    Confetti.State = sprintf('confetti_%d', k);
                    pause(0.01)
                end
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
             pause (1)
             uiresume();
             end
            
        end
    end

    % Clean up the path
    for i=1:length(added_path)
        rmpath(added_path{i});
    end

end




     
