function Td = SistemaTermicoTanque(Te, Q1, Q2, h, T)
    Td = 1/(Area*h)*((T1-T)*Q1+(T2-T)*Q2-Kp*(T-Te));
end

