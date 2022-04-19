function response = aggregate(c,varargin)
%AGGREGATE  Aggregate API Queries
%   DATA = AGGREGATE(C,ITEM), returns a cell array with information on the
%   definition list for all ITEM codes.
%
%   ITEM:
%   'region'        - region
%   'incomelevel'   - income level
%   'lendingtype'   - lending type
%
%   DATA = AGGREGATE(C,ITEM,VAL), returns a list with VAL ,belong to the
%   specific ITEM.
%
%   Examples
%   % To get the definition list for all Region codes
%   data = aggregate(c,'region')
%
%   % retrieve a list of definitions for specific lending type
%   data = aggregate(c,'lendin',{'IBD','IDB'});
%
%   See also wb.

% validate the arguments initially.
narginchk(2, 3);

varargin{1} = validatestring(varargin{1},{'region','incomelevel','lendingtypes'});
if nargin > 2
    if ~iscell(varargin{2}) && ~ischar(varargin{2})
        error('Wrong format of "%s" code.',varargin{1});
    elseif iscell(varargin{2})
        varargin{2} = strjoin(varargin{2},';');
    end
end

% create a complete api url with get string.
url = strjoin({c.url_api,'v2',varargin{:},'?format=json&per_page=99999'},'/');

% retrive and parse data
response = jsondecode(urlread(url));

end

