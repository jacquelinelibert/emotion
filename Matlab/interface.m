function interface
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
%    bottonXpos = disp.width;
    leftBox = uicontrol('Style','pushbutton','String','Left',...
        'Position',[disp.width * 1/4 - round(bottonWidth / 2), bottonYpos, bottonWidth, bottonHeight],...
        'Callback',@left_Callback);
    centerBox = uicontrol('Style','pushbutton','String','Center',...
        'Position',[disp.width * 2/4 - round(bottonWidth / 2), bottonYpos,bottonWidth,bottonHeight],...
        'Callback',@center_Callback);
    rightBox = uicontrol('Style','pushbutton','String','Right',...
        'Position',[disp.width * 3/4 - round(bottonWidth / 2), bottonYpos, bottonWidth, bottonHeight],...
        'Callback',@right_Callback);
   
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
   % initialize response structure
   resp = repmat(struct('key', 0, 'acc', 0), 1, 10);
   % initialize response counter
   iresp = 1;
   
   
   % Make the GUI visible.
   f.Visible = 'on';
 
   %  Callbacks for simple_gui. These callbacks automatically
   %  have access to component handles and initialized data 
   %  because they are nested at a lower level.
 
   % Push button callbacks. Each callback plots current_data in
   % the specified plot type.
   
   function left_Callback(source,eventdata) 
        resp(iresp).key = 'l';
        resp(iresp).key
   end
 
   function center_Callback(source,eventdata) 
       resp(iresp).key = 'c';
       resp(iresp).key
   end
 
   function right_Callback(source,eventdata) 
       resp(iresp).key = 'r';
       resp(iresp).key
   end 
 
end 