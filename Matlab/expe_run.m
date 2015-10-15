function  expe_run%(subject) 
    

    subName = 'name';

    cue = {'normalized', 'intact'};
    cue = cue(randperm(length(cue)));
    for icue = 1 : length(cue);
        phase = {'training', 'test'};
        for iphase = 1 : length(phase)
            fprintf('I am running %s %s %s\n', subName, phase{iphase}, cue{icue})
            Expe_Emotion('simulate', subName, phase{iphase}, cue{icue});
        end
    end
end
