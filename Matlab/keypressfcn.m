function keypressfcn(~,e)
        switch e.Key
            case 'a'
                Clown.State = 'angry';
            case 's'
                Clown.State = 'sad';
            case 'd'
                Clown.State = 'joyful';
        end
  end  