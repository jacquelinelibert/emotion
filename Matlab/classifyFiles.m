function emotionvoices = classifyFiles(soundDir)

% set path differently? 
emotionvoices = dir([soundDir '*.wav']);

%training = (emotionsounds.name(2)=('1'|'3'|'7'|'8'))
% speaker = s1:8;



nFile = length (emotionvoices);

for iFile = 1:nFile 
    switch (emotionvoices(iFile).name(4))
        case '2'
            emotionvoices(iFile).emotion = 'angry'; 
        case '3'
            emotionvoices(iFile).emotion = 'sad';
        case '5'
            emotionvoices(iFile).emotion = 'joyful';
    end 
    switch (emotionvoices(iFile).name(2))
        case {'2', '4', '5', '6'}
            emotionvoices(iFile).phase = 'test'; 
        case {'1', '3', '7', '8'}
            emotionvoices(iFile).phase = 'training';
    end 
        
end


    

