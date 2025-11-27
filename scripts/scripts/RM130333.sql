--Se genera una funcion para obtener el nombre del mes segun su numero
CREATE OR REPLACE FUNCTION FN_NOMBRE_MES (NUM_MES IN NUMBER)
   RETURN VARCHAR2 IS
   NOMBRE_MES VARCHAR2(20); 
BEGIN
   CASE NUM_MES
        WHEN 1 THEN
             NOMBRE_MES := 'ENERO';
        WHEN 2 THEN
             NOMBRE_MES := 'FEBRERO';
        WHEN 3 THEN
             NOMBRE_MES := 'MARZO';
        WHEN 4 THEN
             NOMBRE_MES := 'ABRIL';
        WHEN 5 THEN
             NOMBRE_MES := 'MAYO';
        WHEN 6 THEN
             NOMBRE_MES := 'JUNIO';
        WHEN 7 THEN
             NOMBRE_MES := 'JULIO';
        WHEN 8 THEN
             NOMBRE_MES := 'AGOSTO';
        WHEN 9 THEN
             NOMBRE_MES := 'SEPTIEMBRE';
        WHEN 10 THEN
             NOMBRE_MES := 'OCTUBRE';
        WHEN 11 THEN
             NOMBRE_MES := 'NOVIEMBRE';
        WHEN 12 THEN
             NOMBRE_MES := 'DICIEMBRE';
        ELSE
             NOMBRE_MES := 'MES INVALIDO';
     END CASE;
     RETURN NOMBRE_MES;
END;
/
--Se confirma la creacion de la funcion FN_NOMBRE_MES