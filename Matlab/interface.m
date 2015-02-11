function interface(phase)
    % interface for emotion task

    %  Create and then hide the GUI as it is being constructed.


    screen = monitorSize;
    screen.xCenter = round(screen.width / 2);
    screen.yCenter = round(screen.heigth / 2);
    disp.width = 600;
    disp.heigth = 400;
    disp.Left = screen.left + screen.xCenter - (disp.width / 2);
    %    disp.Down = screen.xCenter + disp.halfWidth;
    disp.Up = screen.bottom + screen.yCenter - (disp.heigth / 2);
    %    disp.Right = screen.yCenter + disp.halfHeigth;

    f = figure('Visible','off','Position',[disp.Left, disp.Up, disp.width, disp.heigth], ...
        'Toolbar', 'none', 'Menubar', 'none', 'NumberTitle', 'off');

    %  Construct the components.
    bottonHeight= 50;
    bottonWidth = 100;
    bottonYpos = round(disp.heigth /2) - round(bottonHeight / 2);
    buttonName = {'Sad', 'Joyful', 'Angry'};
    buttonName = buttonName(randperm(3));
    buttonName{4} = 'START';
    %    bottonXpos = disp.width;
    leftBox = uicontrol('Style','pushbutton','String', buttonName{1},...
        'Position',[disp.width * 1/4 - round(bottonWidth / 2), bottonYpos, bottonWidth, bottonHeight],...
        'Callback',@left_Callback, 'Visible', 'Off');
    centerBox = uicontrol('Style','pushbutton','String', buttonName{4},...
        'Position',[disp.width * 2/4 - round(bottonWidth / 2), bottonYpos,bottonWidth,bottonHeight],...
        'Callback',@center_Callback);
    rightBox = uicontrol('Style','pushbutton','String', buttonName{3},...
        'Position',[disp.width * 3/4 - round(bottonWidth / 2), bottonYpos, bottonWidth, bottonHeight],...
        'Callback',@right_Callback, 'Visible', 'Off');

    % Initialize the GUI.
    % Change units to normalized so components resize
    % automatically.
    f.Units = 'normalized';
    leftBox.Units = 'normalized';
    centerBox.Units = 'normalized';
    rightBox.Units = 'normalized';

    % Assign the GUI a name to appear in the window title.
    f.Name = 'Emotion task';
    % Move the GUI to the center of the screen.
    movegui(f,'center')
    
    % load stimuli for presentation
    soundDir = '../Stimuli/Emotion/Emotion_normalized/';
    emotionvoices = classifyFiles(soundDir);
    options = [];
    [expe, options] = building_conditions2(options);
    
    % initialize response structure
    resp = repmat(struct('key', 0, 'acc', 0), 1, options.(phase).total_ntrials);
    % initialize response counter
    iresp = 0;

%     expe.(phase).condition(iTrial).voicelabel
%     emotionvoices(indexes(toPlay)).emotion
    % Make the GUI visible.
    f.Visible = 'on';

    %  Callbacks for simple_gui. These callbacks automatically
    %  have access to component handles and initialized data
    %  because they are nested at a lower level.

    % Push button callbacks. Each callback plots current_data in
    % the specified plot type.

        function left_Callback(source,eventdata)
            resp(iresp).key = buttonName{1};
            resp(iresp).emotion = emotionvoices(indexes(toPlay)).emotion;
            resp(iresp).acc = strcmp(resp(iresp).key, resp(iresp).emotion);
            resp(iresp).congruent = strcmp(emotionvoices(indexes(toPlay)).emotion, expe.(phase).condition(iTrial).voicelabel);
            iresp = iresp + 1;
            emotionvoices = playfile(iresp, emotionvoices, expe, phase, options, soundDir);
            Continue(emotionvoices);
        end

        function center_Callback(source,eventdata)
            if iresp == 0;
                centerBox.String = buttonName{2};
                set(rightBox, 'Visible', 'On');
                set(leftBox, 'Visible', 'On');
            else
                resp(iresp).key = buttonName{2};
                resp(iresp).emotion = emotionvoices(indexes(toPlay)).emotion;
                resp(iresp).acc = strcmp(resp(iresp).key, resp(iresp).emotion);
                resp(iresp).congruent = strcmp(emotionvoices(indexes(toPlay)).emotion, expe.(phase).condition(iTrial).voicelabel);
            end
            iresp = iresp + 1;
            emotionvoices = playfile(iresp, emotionvoices, expe, phase, options, soundDir);
            Continue(emotionvoices);
        end

        function right_Callback(source,eventdata)
            resp(iresp).key = buttonName{3};
            resp(iresp).emotion = emotionvoices(indexes(toPlay)).emotion;
            resp(iresp).acc = strcmp(resp(iresp).key, resp(iresp).emotion);
            resp(iresp).congruent = strcmp(emotionvoices(indexes(toPlay)).emotion, expe.(phase).condition(iTrial).voicelabel);
            iresp = iresp + 1;
            emotionvoices = playfile(iresp, emotionvoices, expe, phase, options, soundDir);
            save('responses.mat', 'resp');
            Continue(emotionvoices);
        end
    
        function Continue(emotionvoices)
            if isempty(emotionvoices)
                set(rightBox, 'Visible', 'Off');
                set(leftBox, 'Visible', 'Off');
                centerBox.String = 'THANK YOU';
                return;
            end
        end


end

% playfile([soundDir emotionvoices(indexes(toPlay)).name])

function emotionvoices = playfile(iTrial, emotionvoices, expe, phase, options, soundDir)
    
    emotionVect = strcmp({emotionvoices.emotion}, expe.(phase).condition(iTrial).voicelabel);
    phaseVect = strcmp({emotionvoices.phase}, phase);
    possibleFiles = [emotionVect & phaseVect];
    indexes = 1:length(possibleFiles);
    indexes = indexes(possibleFiles);

    toPlay = randperm(length(emotionvoices(indexes)),1);
    
    [y, Fs] = audioread([soundDir emotionvoices(indexes(toPlay)).name]);
    player = audioplayer (y, Fs);
    playblocking (player);
    
    % remove just played file from list of possible sound files
    emotionvoices(indexes(toPlay)) = [];
end

