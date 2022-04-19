function data = query(c,varargin)
%QUERY  Advanced Data Queries
%   DATA = QUERY(C,'SOURCE',SOURCE, NAME-VALUE-PAIRS-ARGUMENT), returns a
%   query result output argument DATA with "SOURCE" source id and
%   NAME-VALUE pairs, NAME is concept and VALUE is concept variables.
%   
%   DATA = QUERY(C,'SOURCE',SOURCE), is the same as
%   "getConceptVariables()" method.
%
%   This method contains the concept and concept variable validation, and
%   that the concept is sorted in the right way.
%
%   Example
%   data = query(c,'source','2','time','YR2010','country','ALB;CHN','series','AG.LND.PRCP.MM')
%
%     data = 
%     
%       struct with fields:
%     
%                page: 1
%               pages: 1
%            per_page: 9999
%               total: 2
%         lastupdated: '2019-01-30'
%              source: [1¡Á1 struct]
%   
%   See also wb/getConceptVariables

narginchk(3,Inf);

if rem(length(varargin),2) == 1
    error('The input arguments be name value pairs. ');
end

if ~strncmpi(varargin{1},'sources',length(varargin{1}))
    error('The first argument must be "sources". ');
end

d = getfield(load(fullfile(c.datapath,'ConceptVariables.mat')),'data');

% find the "concept_variable" information in certain source.
dim = strcmpi(varargin{2},{d.id});
if sum(dim) ~= 1
    error('Wrong source id input. ');
end
d = d(dim).concept_variable; % update the information

% {d.id} must be included in the rest arguments.
argin = {}; % argin is a concept-sorted cell array.
for n = 1:length({d.id})
    m = 3;
    while m <= length(varargin)
        dim = strcmpi(varargin{m},{d(n).id}); % completely match
        if ~dim
            m = m + 2; % go on searching
        else
            d2 = d(n).variable;
            if ~ischar(varargin{m+1}) && ~iscell(varargin{m+1})
                error('Wrong concept variables match with concept name "%s". ',varargin{m});
            elseif ischar(varargin{m+1})
                x = strsplit(varargin{m+1},';');
            else % iscell(varargin{m+1})
                x = varargin{m+1};
            end
            
            % x is used to validate the concept variables
            if ~isequal(x{1},'all') && any(ismember(lower(x),lower({d2.id}) ))~=1
                error('Wrong concept variables match with concept name "%s". ',varargin{m});
            else
                argin = [argin,varargin(m:m+1)];%#ok
                break % escape from while loop
            end
        end
    end
end

% fetch data 
data = getConceptVariables(c,varargin{2},argin{:});

end