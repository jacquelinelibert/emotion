
[G, bkg, Clown, Buttons, screen2] = EmotionGame;
    G.onMouseRelease = @buttondownfcn;
    
    
results = struct();
   
   %=============================================================== MAIN LOOP
while mean([expe.( phase ).conditions.done])~=1 % Keep going while there are some conditions to do
   
   
   while starting == 0
            uiwait();
    end
        
    % Add the response to the results structure
    expe.( phase ).condition(itrial).attempts = expe.( phase ).condition(itrial).attempts + 1;
    n_attempt = expe.( phase ).conditions(itrial).attempts;
    
    previousRespAcc = 1; % accuracy of the previous response
    while true
    




function PlaytheGame 

iTrial = 1;


iTrial = iTrial + 1; 



play sound

clown changes 
buttons appear
wait for response
collect response
go to next trial
update counter 