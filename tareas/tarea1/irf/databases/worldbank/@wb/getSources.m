function data = getSources(c, id)
%GETSOURCES  Advanced Data API Queries: Source Queries
%   DATA = GETSOURCES(C), returns a cell array DATA with information
%   on all sources.
%
%   DATA = GETSOURCES(C,ID), returns DATA with information about a
%   particular source.
%
%   DATA = GETSOURCES(C,{ID1,ID2,...}), returns DATA with information about
%   some sources.
%
%   Examples:
%   % To request information about all sources
%   data = getSources(c);     
%
%   % To request information about a particular source 2
%   data = getSources(c,'2');
%
%   % To request information about a particular source 2 and 3
%   data = getSources(c,{'2','3'});

narginchk(1,2);

% create a complete api url with get string.
if nargin == 1
    url = strjoin({c.url_api,'v2','sources?format=json&per_page=99999'},'/');
end

if nargin == 2
    if ~ischar(id) && ~iscell(id)
        error('Wrong source id input. ');
    elseif ischar(id)
        source = id;
    else % iscell(id)
        source = strjoin(id,';');
    end
    url = strjoin({c.url_api,'v2','sources',...
        sprintf('%s?format=json&per_page=99999',source)},'/');
end

% retrive and parse data
data = jsondecode(urlread(url));
