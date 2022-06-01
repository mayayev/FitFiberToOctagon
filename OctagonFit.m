function varargout = OctagonFit(varargin)
% OCTAGONFIT MATLAB code for OctagonFit.fig
%      OCTAGONFIT, by itself, creates a new OCTAGONFIT or raises the existing
%      singleton*.
%
%      H = OCTAGONFIT returns the handle to a new OCTAGONFIT or the handle to
%      the existing singleton*.
%
%      OCTAGONFIT('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in OCTAGONFIT.M with the given input arguments.
%
%      OCTAGONFIT('Property','Value',...) creates a new OCTAGONFIT or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before OctagonFit_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to OctagonFit_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help OctagonFit

% Last Modified by GUIDE v2.5 31-Dec-2018 11:53:02

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @OctagonFit_OpeningFcn, ...
                   'gui_OutputFcn',  @OctagonFit_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before OctagonFit is made visible.
function OctagonFit_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to OctagonFit (see VARARGIN)

% Choose default command line output for OctagonFit
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes OctagonFit wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = OctagonFit_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in run_fit.
function run_fit_Callback(hObject, eventdata, handles)
% hObject    handle to run_fit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
r_core = str2double(get(handles.core_d, 'String'));
r_clad = str2double(get(handles.clad_d, 'String'));
dr_core = str2double(get(handles.core_tolerance, 'String'));

points = handles.points;
guess_center = mean(points);
d = sqrt((points(:,1)-guess_center(1)).^2 + (points(:,2)-guess_center(2)).^2);

core_points = points(d <= r_core + dr_core,:);
clad_points = points(d > r_core + dr_core,:);
[enclosing_core,enclosed_core] = fit_octagon_direct(core_points);
[enclosing_clad,enclosed_clad] = fit_octagon_direct(clad_points);

% plot
xt_enclosing_core = @(t) enclosing_core.center(1) + cos(enclosing_core.tau)*enclosing_core.semiaxis(1)*cos(t) - sin(enclosing_core.tau)*enclosing_core.semiaxis(2)*sin(t);
yt_enclosing_core = @(t) enclosing_core.center(2) + sin(enclosing_core.tau)*enclosing_core.semiaxis(1)*cos(t) + cos(enclosing_core.tau)*enclosing_core.semiaxis(2)*sin(t);
xt_enclosed_core = @(t) enclosed_core.center(1) + cos(enclosed_core.tau)*enclosed_core.semiaxis(1)*cos(t) - sin(enclosed_core.tau)*enclosed_core.semiaxis(2)*sin(t);
yt_enclosed_core = @(t) enclosed_core.center(2) + sin(enclosed_core.tau)*enclosed_core.semiaxis(1)*cos(t) + cos(enclosed_core.tau)*enclosed_core.semiaxis(2)*sin(t);

xt_enclosing_clad = @(t) enclosing_clad.center(1) + cos(enclosing_clad.tau)*enclosing_clad.semiaxis(1)*cos(t) - sin(enclosing_clad.tau)*enclosing_clad.semiaxis(2)*sin(t);
yt_enclosing_clad = @(t) enclosing_clad.center(2) + sin(enclosing_clad.tau)*enclosing_clad.semiaxis(1)*cos(t) + cos(enclosing_clad.tau)*enclosing_clad.semiaxis(2)*sin(t);
xt_enclosed_clad = @(t) enclosed_clad.center(1) + cos(enclosed_clad.tau)*enclosed_clad.semiaxis(1)*cos(t) - sin(enclosed_clad.tau)*enclosed_clad.semiaxis(2)*sin(t);
yt_enclosed_clad = @(t) enclosed_clad.center(2) + sin(enclosed_clad.tau)*enclosed_clad.semiaxis(1)*cos(t) + cos(enclosed_clad.tau)*enclosed_clad.semiaxis(2)*sin(t);

axes(handles.display_results_plot);
hold off
axis equal
scatter(points(:,1), points(:,2), '.');
hold on
fplot(xt_enclosing_core,yt_enclosing_core, [0 2*pi]);
fplot(xt_enclosed_core,yt_enclosed_core, [0 2*pi]);
fplot(xt_enclosing_clad,yt_enclosing_clad, [0 2*pi]);
fplot(xt_enclosed_clad,yt_enclosed_clad, [0 2*pi]);

% print to screen
% clad
face2face = enclosed_clad.semiaxis;
face2face = mean(face2face);
set(handles.clad_face2face, 'String', mat2str(face2face, 3));
edge2edge = enclosing_clad.semiaxis;
edge2edge = mean(edge2edge);
set(handles.clad_edge2edge, 'String', mat2str(edge2edge, 3));
center_dev = norm(enclosing_clad.center - enclosed_clad.center);
set(handles.clad_center_txt, 'String', mat2str(center_dev, 3));
handles.clad.face2face = face2face;
handles.clad.edge2edge = edge2edge;
handles.clad.center_dev = center_dev;

% core
face2face = enclosed_core.semiaxis;
face2face = mean(face2face);
set(handles.core_face2face, 'String', mat2str(face2face, 3));
edge2edge = enclosing_core.semiaxis;
edge2edge = mean(edge2edge);
set(handles.core_edge2edge, 'String', mat2str(edge2edge, 3));
center_dev = norm(enclosing_core.center - enclosed_core.center);
set(handles.core_center_txt, 'String', mat2str(center_dev, 3));
handles.core.face2face = face2face;
handles.core.edge2edge = edge2edge;
handles.core.center_dev = center_dev;

% concentericity
handles.concentricity.edge2edge = norm(enclosing_core.center - enclosing_clad.center);
set(handles.concentricity_e2e_txt, 'String', mat2str(handles.concentricity.edge2edge, 3));
handles.concentricity.face2face = norm(enclosed_core.center - enclosed_clad.center);
set(handles.concentricity_f2f_txt, 'String', mat2str(handles.concentricity.face2face, 3));


handles.core.enclosing = enclosing_core;
handles.core.enclosed = enclosed_core;
handles.clad.enclosing = enclosing_clad;
handles.clad.enclosed = enclosed_clad;

guidata(hObject, handles);


function core_d_Callback(hObject, eventdata, handles)
% hObject    handle to core_d (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of core_d as text
%        str2double(get(hObject,'String')) returns contents of core_d as a double


% --- Executes during object creation, after setting all properties.
function core_d_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ex (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function clad_d_Callback(hObject, eventdata, handles)
% hObject    handle to clad_d (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of clad_d as text
%        str2double(get(hObject,'String')) returns contents of clad_d as a double


% --- Executes during object creation, after setting all properties.
function clad_d_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ex (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function core_tolerance_Callback(hObject, eventdata, handles)
% hObject    handle to core_tolerance (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of core_tolerance as text
%        str2double(get(hObject,'String')) returns contents of core_tolerance as a double


% --- Executes during object creation, after setting all properties.
function core_tolerance_CreateFcn(hObject, eventdata, handles)
% hObject    handle to core_tolerance (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function clad_tolerance_Callback(hObject, eventdata, handles)
% hObject    handle to clad_tolerance (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of clad_tolerance as text
%        str2double(get(hObject,'String')) returns contents of clad_tolerance as a double


% --- Executes during object creation, after setting all properties.
function clad_tolerance_CreateFcn(hObject, eventdata, handles)
% hObject    handle to clad_tolerance (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




function file_name_Callback(hObject, eventdata, handles)
% hObject    handle to file_name (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
filename = get(hObject,'String');
% handles.points = load(filename);
handles.points = get_data(filename);
guidata(hObject, handles);

% Hints: get(hObject,'String') returns contents of file_name as text
%        str2double(get(hObject,'String')) returns contents of file_name as a double


% --- Executes during object creation, after setting all properties.
function file_name_CreateFcn(hObject, eventdata, handles)
% hObject    handle to file_name (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in browse_files.
function browse_files_Callback(hObject, eventdata, handles)
% hObject    handle to browse_files (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[file,path] = uigetfile({'*.csv'; '*.mat'; '*.txt'; '*.*'});
filename = [path '\' file];
% handles.points = load([path '\' file]);
handles.points = get_data(filename);
guidata(hObject, handles);



% --- Executes on button press in save_mat.
function save_mat_Callback(hObject, eventdata, handles)
% hObject    handle to save_mat (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[file,path] = uiputfile('*.mat');

core = handles.core;
clad = handles.clad;
concentricity = handles.concentricity;
points = handles.points;

save([path '\' file], 'core', 'clad', 'concentricity', 'points');



% --- Executes on button press in save_fig.
function save_fig_Callback(hObject, eventdata, handles)
% hObject    handle to save_fig (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function ex_Callback(hObject, eventdata, handles)
% hObject    handle to ex (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ex as text
%        str2double(get(hObject,'String')) returns contents of ex as a double


% --- Executes during object creation, after setting all properties.
function ex_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ex (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in save_table.
function save_table_Callback(hObject, eventdata, handles)
% hObject    handle to save_table (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[filename,path] = uiputfile('*.txt');

core = handles.core;
clad = handles.clad;

newstruct.name = {'Core - enclosing'; 'core - enclosed'; 'clad - enclosing'; 'clad - enclosed'};
newstruct.center = {core.enclosing.center; core.enclosed.center; clad.enclosing.center; clad.enclosed.center};
newstruct.semiaxis = {core.enclosing.semiaxis; core.enclosed.semiaxis; clad.enclosing.semiaxis; clad.enclosed.semiaxis};
newstruct.tau = {core.enclosing.tau; core.enclosed.tau; clad.enclosing.tau; clad.enclosed.tau};

t = struct2table(newstruct);
writetable(t, [path '\' filename]);
