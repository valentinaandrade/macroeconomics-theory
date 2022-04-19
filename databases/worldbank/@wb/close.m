function close(c) %#ok
%CLOSE  close and delete the connection object in the workspace
%   CLOSE(c), c must be a connection object ,not in char format. The method
%   will clear the object variable from the workspace.
%
%   Example
%   conn = wb();
%   close(conn)

% generate an expression with clear function.
expr = sprintf('clear %s;',inputname(1));

% evalin with "base" option means the variable will be deleted from the
% workspace.
evalin('base',expr);

end

