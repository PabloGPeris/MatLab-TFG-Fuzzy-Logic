classdef FuzzySetArgumento
    %FUZZYSET (t1,v1, ...tn,vn) 
    %   Conjunto borroso que define el número de reglas entre -pi y pi

    properties
        vertex
        func
    end
    
    methods
        function obj = FuzzySetArgumento(varargin)
            %FUZZYSET(t1,v1, ...tn,vn) Constructor de FuzzySet
            %   t es el tipo de función
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
            %   v son los vértices asociados, de dimensiones:
            %   1 para Delta
            %   2 para Pi
            %   Indiferente para no borroso
            if  mod(nargin, 2) ~= 0
                error('Debe haber múltiplo de 2 argumentos');
            elseif nargin < 2
                error('Argumentos insuficientes');
            end
            
            N = nargin/2;
            
            obj.vertex = zeros(1, N);
            
            for i = 1:N
                obj.func(i).type = varargin{2*i-1};
                if obj.func(i).type == 'D'
                    obj.vertex(i) = varargin{2*i};
                    obj.func(i).width = 0;
                elseif obj.func(i).type == 'P'
                    obj.vertex(i) = (varargin{2*i}(2) + varargin{2*i}(1))/2;
                    obj.func(i).width = (varargin{2*i}(2) - varargin{2*i}(1))/2;
                elseif obj.func(i).type == '-'
                    obj.vertex(i) = 0;
                    obj.func(i).width = 0;
                else 
                    error('Función de pertenencia no reconocida; se reconocen D, P, -');
                end
            end
            
            if N > 1
                obj.vertex = [obj.vertex(N)-2*pi obj.vertex obj.vertex(1)+2*pi];
                obj.func = [obj.func(N) obj.func obj.func(1)];
            end
            
        end
        
        function outputArg = Fuzzification(obj, inputArg)
            %FUZZIFICATION(obj, inputArg) Borrosifica el argumento de
            %entrada según el FuzzySet
            
            N = length(obj.vertex);
            
            output1 = zeros(1,N);
            for i = 1:N
                
                if i == 1
                    M = 1;
                else
                    M = i-1;
                end
                
                if i == N
                    K = N;
                else
                    K = i+1;
                end
                
                switch obj.func(i).type
                case 'D'
                    output1(i) = Delta_function( [obj.vertex(M)+obj.func(M).width, ... 
                        obj.vertex(i), obj.vertex(K)-obj.func(K).width], inputArg);
                case 'P'
                    output1(i) = Pi_function([obj.vertex(M)+obj.func(M).width, ...
                        obj.vertex(i)-obj.func(i).width, obj.vertex(i)+obj.func(i).width, obj.vertex(K)-obj.func(K).width], inputArg);
                case '-'
                    output1(i) = 1; %No hay función borrosa
                otherwise
                    error('Error al reconocer funciones borrosas');                                                
                end
            end
            
            if N > 1
                outputArg = output1(2:N-1);
                outputArg(1) = outputArg(1) + output1(N);
                outputArg(N-2) = outputArg(N-2) + output1(1);
            else
                outputArg = output1;
            end
        end
        
        function outputArg = FSLength(obj)
            if length(obj.vertex) ~=1
                outputArg = length(obj.vertex) - 2;
            else
                outputArg = 1;
            end
        end
        
        function plotFS(obj, nintervalos)
            inicio = -pi;
            fin = pi;
            nv = FSLength(obj);
            grafica = zeros(nv, nintervalos);
            x = linspace(inicio, fin, nintervalos + 1);
            for i = 1:(nintervalos + 1)
                grafica(:,i) = (Fuzzification(obj, x(i)))';
            end
            figure;
            for j = 1:nv
                plot(x, grafica(j,:));
                hold on;
            end
        end
    end
    
    methods(Static)
    	function outputArg = format(varargin)
            %FUZZYSET ({c1} {c2} ... {cn})
            %   Permite transformar formato simple simple en el formato
            %   correcto para el constructor de FuzzySet.
            if nargin == 1
                outputArg{1} = '-';
                outputArg{2} = 0;
                return;
            end
            outputArg = cell(1, 2*nargin);
            for i = 1:nargin
                if length(varargin{i}) == 1
                    outputArg{2*i - 1} = 'D';
                elseif length(varargin{i}) == 2
                    outputArg{2*i - 1} = 'P';
                else
                    error('Lectura de argumentos');
                end
                outputArg(2*i) = varargin(i);
            end
        end
    end
end
        
function outputArg = Delta_function(vertex, inputArg)
    if inputArg < vertex(1)
    	outputArg = 0;
    elseif inputArg > vertex(3)
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
    if inputArg >= vertex(2) && inputArg <= vertex(3)
    	outputArg = 1;
    elseif inputArg > vertex(4)
    	outputArg = 0;
	elseif inputArg < vertex(1)
        outputArg = 0;
	elseif inputArg < vertex(2)
    	outputArg = (inputArg - vertex(1)) / ...
                    (vertex(2) - vertex(1));
	else
        outputArg = 1 - (inputArg - vertex(3)) / ...
        (vertex(4) - vertex(3));
    end
end
