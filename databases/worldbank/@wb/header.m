function req = header(c,varargin)
%HEADER  create query structs for send method.
%   A method in "API Basic Call Structures".
%
%   REQUEST = HEADER(C, QUERY1, VALUE1, ...), returns a query struct after
%   some simple validation precedure.
%
%   Examples:
%   req = header(c,'country','all','indicator','SP.POP.TOTL','date','2000');
%
%   % Multiple countries & indicators
%   req = header(c,'country','chn;ago','indicator','AG.AGR.TRAC.NO;SP.POP.TOTL','source','2');
%
%   See also wb/send, wb.

% initialize the request header
req = struct('country',[],...
    'indicator' ,[],...
    'date'      ,[],...
    'page'      ,[],...
    'per_page'  ,[],...
    'mrv'       ,[],...
    'mrnev'     ,[],...
    'gapfill'   ,[],...
    'frequency' ,[],...
    'footnote'  ,[],...
    'source'    ,[]);

% get the fieldnames of header in order to validate arguments
field = fieldnames(req);

% validate the query options
for n = 1:2: length(varargin)
    chk = strncmpi(varargin{n}, field, length(varargin{n}) );
    if sum(chk) == 0 || sum(chk) > 1
        error('Query option is incorrect. ');
    end
end

% validate the query values
for n = 2:2: length(varargin)
    option = field{ strncmpi(varargin{n-1}, field, length(varargin{n-1})) };
    if strcmpi(option,'gapfill') || strcmpi(option,'footnote')
        if ~strcmpi(varargin{n}, 'y') && ~strcmpi(varargin{n}, 'n')
            error('%s value must be Y/N. ', option);
        end
    elseif strcmpi(option,'frequency')
        if ~strcmpi(varargin{n}, 'y') && ~strcmpi(varargin{n}, 'q') && ~strcmpi(varargin{n}, 'm')
            error('frequency value must be Y/Q/M. ');
        end
    end
    
    % assign value to the header
    req.(option) = varargin{n}; 
end