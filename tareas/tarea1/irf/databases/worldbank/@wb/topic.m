function data = topic(c,val)
%TOPIC  Topic API Queries
%   DATA = TOPIC(C), return the lists of all topics.
%
%   DATA = TOPIC(C,VAL), return the list of the specific topic VAL.
%
%   DATA = TOPIC(C,{VAL1,___}), return the lists of some topics.
%
%   Example: data = topic(c);
%
%   See also wb, wb/country.

% parse arguments
narginchk(1,2);

if nargin == 1
    val = {};
end
if nargin > 1
    if ~ischar(val) && ~iscell(val)
        error('Wrong topic value inputs. ');
    elseif iscell(val)
        val = strjoin(val,';');
    end
    val = {val};
end

% create a complete api url with get string.
url = strjoin({c.url_api,'v2','topic',val{:},'?format=json&per_page=5000'},'/');

% retrive and parse data
data = jsondecode(urlread(url));
end


