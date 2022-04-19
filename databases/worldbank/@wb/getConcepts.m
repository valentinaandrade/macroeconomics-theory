function data = getConcepts(c,source,concept)
%GETCONCEPTS  Advanced Data API Queries: Concepts Queries
%   Notice: concept variable is established on source id having been input.
%
%   DATA = GETCONCEPTS(C,SOURCE), retrieve data about a certain SOURCE id.
%
%   DATA = GETCONCEPTS(C,SOURCE,CONCEPT), returns DATA about the specific
%   concept in SOURCE id.
%
%   DATA = GETCONCEPTS(C,SOURCE,{CONCEPT1,CONCEPT2,...}, returns DATA about
%   some concepts in SOURCE id.
%
%   Examples:
%   % get all concept variables in source 2.
%   data = getConcepts(c,'2');
%
%   % 'country' is a concept variable in source 2.
%   data = getConcepts(c,'2','country');
%
%   % 'country','time' are both concepts in source 2.
%   data = getConcepts(c,'2',{'country','time'});
%
%   See also wb/getSources

narginchk(2,3);

% create a complete api url with get string.
if nargin == 2
    url = strjoin({c.url_api,'v2','sources',source,'concepts',...
        'data?format=json&per_page=99999'},'/');
end

if nargin == 3
    if ~ischar(concept) && ~iscell(concept)
        error('Wrong concept id input. ');
    elseif ischar(concept)
        concept = deal(concept);
    else % iscell(id)
        concept = strjoin(concept,';');
    end
    url = strjoin({c.url_api,'v2','sources',source,'concepts',...
        concept,'data?format=json&per_page=99999'},'/');
end

% retrive and parse data
data = jsondecode(urlread(url));