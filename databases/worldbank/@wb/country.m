function data = country(c,val,varargin)
%COUNTRY  Country API Queries
%   DATA = country(C, VAL), returns information about VAL. 
%
%   DATA = country(C), returns a list of all countries.
%
%   Example:
%   % List all countries:
%   data = country(c)
%
%   % Fetch the specific country:
%   data = country(c,'br');
%
%   % You can also try this:
%   data = country(c,'all');
%
%   See also wb. 

% parse arguments
narginchk(1,4);

if nargin == 1
    val = {};
end
if nargin > 1
    if ~ischar(val) && ~iscell(val)
        error('Wrong country value inputs. ');
    elseif iscell(val)
        val = strjoin(val,';');
    end
    val = {val};
end

% create a complete api url with get string.
e = create_connector(varargin{:},'format','json','per_page','5000');
url = [strjoin({c.url_api,'v2','country',val{:}},'/'),e];

% retrive and parse data
data = jsondecode(urlread(url));
end

