classdef FuzzySet
    %FUZZYSET Summary of this class goes here
    %   Detailed explanation goes here

    properties
        vertex
        func
    end
    
    methods
        function obj = FuzzySet(varargin)
            %FUZZYSET(t1,v1, ...tn,vn) Constructor de FuzzySet
            %   t es el tipo de funci�n
            %   L - 'L'
            % ______
            %       \
            %        \
            %         \______
            %   Gamma - 'G'
            %          ______
            %         /
            %        /
            % ______/
            %   Delta - 'D'
            %        /\
            %       /  \
            % _____/    \_____
            %   Pi - 'P'
            %       ____
            %      /    \
            %     /      \
            % ___/        \___
            %   No borroso - '-'
            %
            %__________________
            %   
            %   v son los v�rtices asociados, de dimensiones:
            %   1 para L, Gamma y Delta
            %   2 para Pi
            %   Indiferente para no borroso
            if  mod(nargin, 2) ~= 0
                error('Debe haber m�ltiplo de 2 argumentos');
            elseif nargin < 2
                error('Argumentos insuficientes');
            end
            obj.vertex = zeros(1, nargin/2);
            for i = 1:nargin/2
                obj.func(i).type = varargin{2*i-1};
                if obj.func(i).type == 'L' || obj.func(i).type == 'G' || obj.func(i).type == 'D'
                    obj.vertex(i) = varargin{2*i};
                    obj.func(i).width = 0;
                elseif obj.func(i).type == 'P'
                    obj.vertex(i) = (varargin{2*i}(2) + varargin{2*i}(1))/2;
                    obj.func(i).width = (varargin{2*i}(2) - varargin{2*i}(1))/2;
                elseif obj.func(i).type == '-'
                    obj.vertex(i) = 0;
                    obj.func(i).width = 0;
                else 
                    error('Funci�n de pertenencia no reconocida; se reconocen L, G, D, P, -');
                end
            end
        end
        
        function outputArg = Fuzzification(obj, inputArg)
            %METHOD1 Summary of this method goes here
            %   Detailed explanation goes here
            outputArg = zeros(1,length(obj.vertex));
            for i = 1:length(obj.vertex)
                switch obj.func(i).type
                case 'L'
                    outputArg(i) = L_function([obj.vertex(i), obj.vertex(i+1)-obj.func(i+1).width], inputArg);
                case 'G'
                    outputArg(i) = Gamma_function([obj.vertex(i-1)+obj.func(i-1).width, obj.vertex(i)], inputArg);
                case 'D'
                    outputArg(i) = Delta_function([obj.vertex(i-1)+obj.func(i-1).width, obj.vertex(i), obj.vertex(i+1)-obj.func(i+1).width], inputArg);
                case 'P'
                    outputArg(i) = Pi_function([obj.vertex(i-1)+obj.func(i-1).width, obj.vertex(i)-obj.func(i).width, obj.vertex(i)+obj.func(i).width, obj.vertex(i+1)-obj.func(i+1).width], inputArg);
                case '-'
                    outputArg(i) = 1; %No hay funci�n borrosa
                otherwise
                    error('Error al reconocer funciones borrosas');                                                
                end
            end
        end
        
        function outputArg = FSLength(obj)
           outputArg = length(obj.vertex);
        end
    end
    
    methods(Static)
    	function outputArg = format(varargin)
            %FUZZYSET Constructor de FuzzySet
            %   Detailed explanation goes here 
            if nargin == 1
                outputArg{1} = '-';
                outputArg{2} = 0;
                return;
            end
            outputArg = cell(1, 2*nargin);
            outputArg{1} = 'L';
            outputArg(2) = varargin(1);
            for i = 2:nargin-1
                if length(varargin{i}) == 1
                    outputArg{2*i - 1} = 'D';
                elseif length(varargin{i}) == 2
                    outputArg{2*i - 1} = 'P';
                else
                    error('Lectura de argumentos');
                end
                outputArg(2*i) = varargin(i);
            end
            outputArg{2*nargin-1} = 'G';
            outputArg(2*nargin) = varargin(nargin);
        end
    end
end


function outputArg = L_function(vertex, inputArg)
    if inputArg <= vertex(1)
    	outputArg = 1;
    elseif inputArg >= vertex(2)
        outputArg = 0;
    else
        outputArg = 1 - (inputArg - vertex(1)) / ...
                        (vertex(2) - vertex(1));
    end
end
              
function outputArg = Gamma_function(vertex, inputArg)
	if inputArg <= vertex(1)
    	outputArg = 0;
    elseif inputArg >= vertex(2)
        outputArg = 1;
    else
        outputArg = (inputArg - vertex(1)) / ...
                    (vertex(2) - vertex(1));
	end
end
        
function outputArg = Delta_function(vertex, inputArg)
    if inputArg <= vertex(1)
    	outputArg = 0;
    elseif inputArg >= vertex(3)
        outputArg = 0;
    elseif inputArg <= vertex(2)
        outputArg = (inputArg - vertex(1)) / ...
                    (vertex(2) - vertex(1));
    else
    	outputArg = 1 - (inputArg - vertex(2)) / ...
                        (vertex(3) - vertex(2));
    end
end
        
function outputArg = Pi_function(vertex, inputArg)
    if inputArg <= vertex(1)
        outputArg = 0;
    elseif inputArg >= vertex(4)
    	outputArg = 0;
	elseif inputArg >= vertex(2) && inputArg <= vertex(3)
    	outputArg = 1;
	elseif inputArg < vertex(2)
    	outputArg = (inputArg - vertex(1)) / ...
                    (vertex(2) - vertex(1));
	else
        outputArg = 1 - (inputArg - vertex(3)) / ...
        (vertex(4) - vertex(3));
    end
end

