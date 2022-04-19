classdef wb < handle
%WB  creating an WB api connection object
%   c = WB()  If the network is smooth, c can be returned as a connection
%   object, or the WB function throws error.
%   
%   Properties of a WB object
%       url   - webite: http://www.worldbank.org
%       root  - the root folder of the current file.
%
%   Example: 
%   conn = WB()
%
%   conn = 
% 
%       wb with properties:
% 
%          url: 'http://www.worldbank.org'
%         root: 'D:\Program Files\MATLAB\Documents\@wb'
%
%   See also wb/getSources, wb/getConcepts, wb/getConceptVariables,
%       wb/query, wb/completion, wb/aggregate, wb/country, wb/indicator,
%       wb/send, wb/header, wb/topic, wb/isconnection, wb/close.

    properties(SetAccess = private, GetAccess = public)
        url  = 'http://www.worldbank.org';
        root = fileparts(mfilename('fullpath'));
    end
    properties(Hidden = true, SetAccess = private)
        datapath = fullfile(fileparts(mfilename('fullpath')),'data');
        url_api = 'http://api.worldbank.org';
    end
    
    methods
        function c = wb()
            %WB WorldBank api Access
            
            % check the connection
            if ~isconnection(c)
                error('Unable to retrieve data from worldbank api website. ');
            end
            
            % import dataset from the network
            importdataset(c);
        end
        
        % Basic Methods
        X = isconnection(c);
        close(c);
        importdataset(c);
        %delete(c);
        
        % Advanced Data API Queries Methods
        data = getSources(c, id);
        data = getConcepts(c,source,concept);
        data = getConceptVariables(c,source,varargin);
        data = query(c,varargin);
        [choices,tbl] = completion(c,name,varargin);
        
        % Aggregate API Queries Methods
        response = aggregate(c,varargin);
        
        % Country API Queries Methods
        data = country(c,val,varargin);
        
        % Indicator API Queries Methods
        data = indicator(c,val,varargin);
        
        % API Basic Call Structures
        response = send(c,req,varargin);
        req = header(c,varargin);
        
        % Topic API Queries Methods
        data = topic(c,val);
    end
end