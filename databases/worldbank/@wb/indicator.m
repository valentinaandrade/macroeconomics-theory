function data = indicator(c,val,varargin)
%INDICATOR  Indicator API Queries
%   DATA = INDICATOR(C,VAL), returns a list of VAL in Indicator 
%   aggregate.
%
%   DATA = INDICATOR(C,VAL,QUERY,VALUE,__), returns a list of VAL with
%   additional request headers by get method.
%
%   DATA = INDICATOR(C), returns a list of the first 5000 indicators.
%
%   Example:
%   % get a list of the indicators of source 2
%   data = indicator(c,[],'source','2');
%
%   % get a list of indicator "NY.GDP.MKTP.CD".
%   data = indicator(c,{'NY.GDP.MKTP.CD'});
%
%   See also wb. 

% parse arguments
narginchk(1,Inf);

if nargin == 1 || isempty(val)
    val = {};
end
if nargin > 1 && ~isempty(val)
    if ~ischar(val) && ~iscell(val)
        error('Wrong indicator value inputs. ');
    elseif iscell(val)
        val = strjoin(val,';');
    end
    val = {val};
end

% validate the request header inputs
for n = 2:2:length(varargin)
    if ~iscell(varargin{n}) && ~ischar(varargin{n})
        error('Wrong format of request header. ');
    elseif iscell(varargin{n})
        varargin{n} = strjoin(varargin{n},';');
    end
end

% create a complete api url with get string.
url = strjoin({c.url_api,'v2','indicator',val{:} },'/');

% create the query string by "get" requests
querystring = create_connector(varargin{:},'format','json','per_page','5000');

% add the query string to the original url
url = strcat(url, querystring);

% retrive and parse data
data = jsondecode(urlread(url));
end

