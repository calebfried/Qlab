function [get_settings_fcn, set_settings_fcn] = TimeSweepGUI(parent, bottom, left, name)
% TIMESWEEP
%-------------------------------------------------------------------------------
% File name   : TimeSweep.m
% Generated on: 17-Jun-2011 17:18:34          
% Description :
%-------------------------------------------------------------------------------


% Initialize handles structure
handles = struct();

% if there is no parent figure given, generate one
if nargin < 1 || ~isnumeric(parent)
	handles.figure1 = figure( ...
			'Tag', 'figure1', ...
			'Units', 'characters', ...
			'Position', [103.833333333333 13.8571428571429 85 12], ...
			'Name', 'Time settings', ...
			'MenuBar', 'none', ...
			'NumberTitle', 'off', ...
			'Color', get(0,'DefaultUicontrolBackgroundColor'));
	
	left = 10.0;
	bottom = 10.0;
	name = ['Time settings'];
else
	handles.figure1 = parent;
	name = ['Time settings ' name];
end

% Create all UI controls
build_gui();

settings = struct();
set_GUI_fields(settings);

% Assign function handles output
get_settings_fcn = @get_settings;
set_settings_fcn = @set_GUI_fields;

%% ---------------------------------------------------------------------------
	function build_gui()
% Creation of all uicontrols

		% --- PANELS -------------------------------------
		handles.uipanel2 = uipanel( ...
			'Parent', handles.figure1, ...
			'Tag', 'uipanel2', ...
			'Units', 'pixels', ...
			'Position', [left bottom 425 115], ...
			'FontName', 'Helvetica', ...
			'FontSize', 10, ...
			'Title', name);

		% --- STATIC TEXTS -------------------------------------
		handles.text4 = uicontrol( ...
			'Parent', handles.uipanel2, ...
			'Tag', 'text4', ...
			'Style', 'text', ...
			'Units', 'characters', ...
			'Position', [1.8 4.37362637362637 21 1.07692307692308], ...
			'FontName', 'Helvetica', ...
			'FontSize', 10, ...
			'String', 'Start time (ns)');

		handles.text5 = uicontrol( ...
			'Parent', handles.uipanel2, ...
			'Tag', 'text5', ...
			'Style', 'text', ...
			'Units', 'characters', ...
			'Position', [24 4.37362637362637 21 1.07692307692308], ...
			'FontName', 'Helvetica', ...
			'FontSize', 10, ...
			'String', 'Step (ns)');

		% --- EDIT TEXTS -------------------------------------
		handles.start = uicontrol( ...
			'Parent', handles.uipanel2, ...
			'Tag', 'start', ...
			'Style', 'edit', ...
			'Units', 'characters', ...
			'Position', [2.8 2.83516483516483 19.4 1.53846153846154], ...
			'FontName', 'Helvetica', ...
			'FontSize', 10, ...
			'BackgroundColor', [1 1 1], ...
			'String', '0');

		handles.step = uicontrol( ...
			'Parent', handles.uipanel2, ...
			'Tag', 'step', ...
			'Style', 'edit', ...
			'Units', 'characters', ...
			'Position', [25 2.83516483516483 19.4 1.53846153846154], ...
			'FontName', 'Helvetica', ...
			'FontSize', 10, ...
			'BackgroundColor', [1 1 1], ...
			'String', '1');

    end

    function value = get_numeric(hObject)
		value = str2num(get(hObject, 'String'));
	end

	function settings = get_settings()
		settings = struct();
		
		settings.type = 'sweeps.Time';
		settings.start = get_numeric(handles.start);
		settings.step = get_numeric(handles.step);
    end

    function set_GUI_fields(settings)
        
        defaults.type = 'sweeps.Time';
        defaults.start = 0;
        defaults.step = 1;
        
        if ~isempty(fieldnames(settings))
			fields = fieldnames(settings);
			for i = 1:length(fields)
				name = fields{i};
				defaults.(name) = settings.(name);
			end
        end
        
        set(handles.start,'String',num2str(defaults.start));
        set(handles.step,'String',num2str(defaults.step));
        
    end

end
