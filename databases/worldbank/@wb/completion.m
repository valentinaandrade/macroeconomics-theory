function [choices,tbl] = completion(c,name,varargin)
%COMPLETION  a special method mainly used for tab completions.
%
%  This function also guide users how to make queries more conveniently.
%
%   Example (query)
%   % To know the first arguments to input.
%   name = char(@query);
%   choices = completion(c,name);
%
%   % Then you know the first input argument should be 'source'.
%   % To get all 'sources' from the local database.
%   choices = completion(c,name,[]);
%
%   % If you want to show the list of it.
%   [~,tbl] = completion(c,name,[]);
%
%   % If you choose '2' as your source id, you want to know more about the
%   specific source.
%   [~,tbl] = completion(c,name,[],'2');
%
%           id          value
%         _________    _________
%
%         'Country'    'Country'
%         'Series'     'Series'
%         'Time'       'Time'
%
%    % You want to know something about the 'series' concept variables.
%    [~,tbl] = completion(c,name,[],'2','series')
%
%     tbl =
%
%       1599¡Á2 table
%
%                    id                                                                                     value
%         ___________________________    ______________________________________________________________________________________________________________________________________________
%
%         'AG.AGR.TRAC.NO'               'Agricultural machinery, tractors'
%         'AG.CON.FERT.PT.ZS'            'Fertilizer consumption (% of fertilizer production)'
%         'AG.CON.FERT.ZS'               'Fertilizer consumption (kilograms per hectare of arable land)'
%         'AG.LND.AGRI.K2'               'Agricultural land (sq. km)'
%         'AG.LND.AGRI.ZS'               'Agricultural land (% of land area)'
%         'AG.LND.ARBL.HA'               'Arable land (hectares)'
%         'AG.LND.ARBL.HA.PC'            'Arable land (hectares per person)'
%         ...
%
%   See also wb/importdataset, wb.

narginchk(1, 5);
nargoutchk(0, 2);

switch name
    
    case {'getSources'}
        data = load_data(c, 'Sources.mat');
        tbl = struct2table(data);
        choices = {data.id};
        
    case {'getConcepts'}
        data = load_data(c, 'Concepts.mat');
        
        if nargin == 2
            
            % Actually, nargin == 2, the "nameinput" is useless, call the
            % current function with 'getSource' name input.
            %
            
            [choices, tbl] = completion(c, 'getSources');
            
        elseif nargin == 3
            % nargin == 3, need to search deeper concept information.
            
            idx = strcmpi(varargin{1},{data.id});
            
            choices = {data(idx).concept.id};
            tbl = struct2table(data(idx).concept);
            
        end
        
    case {'getConceptVariables'}
        data = load_data(c, 'ConceptVariables.mat');
        
        if nargin == 2
            % in this case, the same as the completion function with
            % "getConcepts", however the number of outputs.
            
            [choices,tbl] = completion(c, 'getConcepts');
            
        elseif nargin == 3
            % in this case, the same as the completion function with
            % "getConcepts" name input, so the same as the codes ahead.
            
            [choices,tbl] = completion(c, 'getConcepts',varargin{:});
            
        elseif nargin == 4
            
            % at first, get the information of the specfic source
            idx = strcmpi(varargin{1},{data.id});
            data = data(idx).concept_variable;
            
            % get the information of the specific concept
            idx = strcmpi(varargin{2},{data.id});
            
            % output information
            choices = {data(idx).variable.id};
            tbl = struct2table(data(idx).variable) ;
            
        end
    case {'query'}
        
        if nargin == 2
            % no varargin means the second argument of query function must be
            % 'source'.
            choices = {'source'};
            tbl     = [];
            return
            
        elseif nargin > 3
            % "query" name input is the same as "getConceptVariables" name
            [choices,tbl] = completion(c,'getConceptVariables',varargin{2:end});
            
        else % nargin == 2, get the source infomation
            
            [choices,tbl] = completion(c,'getSources');
            
        end
        
    case {'country'}
        data = load_data(c, 'Country.mat');
        
        choices = {data.id};
        tbl     = struct2table(data);
        
    case {'topic'}
        data = load_data(c, 'Topic.mat');
        
        choices = {data.id};
        tbl     = struct2table(data);
        
    case {'aggregate'}
        % incomelevel
        % lendingtype
        % region
        
        if nargin == 2
            tbl = [];
            choices = {'region','incomelevel','lendingtype'};
            
        elseif nargin == 3
            
            varargin{1} = validatestring(varargin{1},{'region','incomelevel','lendingtypes'});
            switch varargin{1}
                
                case {'region'}
                    data = load_data(c, 'Region.mat');
                case {'incomelevel'}
                    data = load_data(c, 'Incomelevel.mat');
                case {'lendingtypes'}
                    data = load_data(c, 'Lendingtypes.mat');
            end
            
            choices = {data.id};
            tbl     = struct2table(data);
        end
    case {'indicator'}
        
        data = load_data(c, 'Indicators.mat');
        
        if nargin == 2
            
            choices = {data.id};
            tbl     = struct2table(data);
        elseif nargin == 3
            % this case means, users don't know the indicator id, they want
            % to find it through source codes, so they onlu need to know
            % the source query name. 
            choices = {'source'};
            tbl     = [];
        elseif nargin == 4
            % we don't care what varargin{1} is, because it's a
            % transitional parameter.
            %
            % but we will also never mind what varargin{2} is, because we
            % consider that if user try to input the fourth arguments, they
            % don't know how to input source_id argument in "indicator"
            % method.
            [choices,tbl] = completion(c, 'getSources');
            
        elseif nargin == 5
            % if this case be involved, user must have input the correct
            % source codes, we only narrow down the data having been
            % imported by load_data subfunction.
            source = varargin{end};
            idx = [];
            for n = 1:length(data)
                for m = 1:length(data(n).source)
                    if strcmpi(source,data(n).source(m).id)
                        idx = [idx,n]; %#ok
                            break
                    end
                end
            end
            choices = {data(idx).id};
            tbl     = struct2table(data(idx));
        end
    otherwise
        error('Wrong function name input. ');

end
end

function data = load_data(c,fcn_name)

data = getfield( load( fullfile(c.datapath, fcn_name)  ),'data');

end