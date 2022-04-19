function data = getConceptVariables(c,source,varargin)
%GETCONCEPTVARIABLES  Advanced Data API Queries: Concept Variables Queries
%   DATA = GETCONCEPTVARIABLES(C,SOURCE,CONCEPT), returns a concept
%   variable dataset of a specific source.
%   
%   DATA = GETCONCEPTVARIABLES(C,SOURCE,CONECPT,'all'), may be the same as
%   the expression above.
%
%   DATA = GETCONCEPTVARIABLES(C,SOURCE,NAME VALUE pairs), returns a cell
%   array determined by the varargin and source, varargin can be input by
%   name value pairs of "concept id" AND "concept variable".
%
%   The following examples
%   % To request a list of all available variables in a concept
%   data = getConceptVariables(c,'2','country');
%
%   % To retrieve a specific concept variable detail for a source
%   % "country": concept. "ALB": concept variables
%   data = getConceptVariables(c,'2','country','ALB');
%
%   See also wb/getSources ,wb/getConcepts.

narginchk(3,Inf);

% create a complete api url with get string.

for n = 1:length(varargin)
    if ~ischar(varargin{n}) && ~iscell(varargin{n})
        error('Wrong concept name or value input. ');
    elseif iscell(varargin{n})
        varargin{n} = strjoin(varargin{n},';');
    end
end
s = strcat('/',strjoin(varargin,'/'));

url = strcat(c.url_api,'/v2/sources/',source, s,...
    '/data?format=json&per_page=9999');

% retrive and parse data
data = jsondecode(urlread(url));