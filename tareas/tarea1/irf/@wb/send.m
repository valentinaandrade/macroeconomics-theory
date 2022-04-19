function response = send(c,req,varargin)
%SEND  API Basic Call Structures: send method after building queries.
%
%   DATA = SEND(C,REQUSET), REQUEST is the output argument of HEADER method
%   , REQUEST is a structure array with fields having been implemented
%   beforehand.
%
%   DATA = SEND(C,REQUEST,NAME-VALUE pairs), The following two ways to
%   input are the same actually.
%
%   % A. Inputs contain varargin. 
%     data1 = send(c, ...
%         header(c,'country','chn;ago','indicator','AG.AGR.TRAC.NO;SP.POP.TOTL'),...
%         'source','2');
%
%   % B. Inputs without varargin.
%   request = header(c,'country','chn;ago','indicator','AG.AGR.TRAC.NO;SP.POP.TOTL','source','2');    
%   data2 = send(c,request);
%
%   L = isequal(data1,data2);
%
%   See also wb/header, wb.

narginchk(2,Inf);

% check the req.per_page
if isempty(req.per_page)
    req.per_page = '5000';
end

% check the req.country and req.indicator!
if isempty(req.country), req.country = 'all'; end
if isempty(req.indicator), req.indicator = 'all'; end

% create a url string without endpoints
url = sprintf(strcat(c.url_api,'/v2/country/%s/indicator/%s'),...
    req.country,req.indicator);

% add endpoints

argin = {'format','json'}; % initialize argin

% delete the fields having been parsed.
req = rmfield(req,{'country', 'indicator'});

field = fieldnames(req);
for n = 1:length(field)
    if ~isempty(req.(field{n}) )
        argin = {argin{:}, field{n}, req.(field{n}) };
    end
end

% add additional query strings
argin = {argin{:}, varargin{:} };

% create the query connector
querystrings = create_connector(argin{:});

% cat the url and query string
url = horzcat(url, querystrings);

% retrive and parse data
response = jsondecode(urlread(url));

end

