function X = isconnection(c)
%ISCONNECTION  check if one can read content from the api website.
%
%   X = ISCONNECTION(c), return a logical variable if X is true. Then you
%   can connect to the worldbank official website, while false means 
%   network failed.
%

% try to get response from the url_api property of the connection object, if the
% exception being caught, network may fail.
try
    %urlread(c.url_api,'charset','utf-8');
    
    % create the uri object 
    uri = matlab.net.URI(c.url_api);
    
    % create the request message
    req = matlab.net.http.RequestMessage();
    
    % send message in order to expect for the response
    res = send(req, uri);
    
    X = true;
catch
    
    X = false;  
end