function [A_, B_, C_] = Modelo_Incremental(A, B, C)
%MODELO_INCREMENTAL Devuelve las matrices expandidas A_, B_ y C_ del
%espacio de estados incremental a partir de las matrices A, B y C

A_ = [ eye(size(C,1))             C*A  ; 
       zeros(length(A),size(C,1)) A   ];
  
B_ = [ C*B  ;
       B   ];

C_ = [eye(size(C,1))  zeros(size(C,1), length(A))];
end

