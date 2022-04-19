function str = create_connector(varargin)
% the endpoint string created by the request of "get" method.

% ?name1=value1&name2=value2...

if nargin/2 ~= floor(nargin/2)
    error('Must input name value arguments.');
end
if any(cellfun(@(x)~ischar(x),varargin))
    error('All inputs must be char arrays. ');
end

op_eql = repmat({'='},1,nargin/2);
op_and = repmat({'&'},1,nargin/2);
op_and{end} = '';
w = [varargin(1:2:end); op_eql; varargin(2:2:end); op_and];
str = ['?',horzcat(w{:})];
