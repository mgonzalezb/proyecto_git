DECLARE
   CURSOR cur_datos_conjuntos_gc IS
      SELECT *
      FROM   SLU.BCONJUNTO_GC;
BEGIN
   FOR rec_datos_conjuntos_gc IN cur_datos_conjuntos_gc LOOP
      INSERT INTO SLU.HCONJUNTO_GC (O_CONJUNTO_HIST,
                                    O_CONJUNTO,   
                                    C_CONJUNTO,  
                                    XC_CONJUNTO,  
                                    XL_CONJUNTO, 
                                    X_OPERACION,
                                    X_QUERY_COUNT,
                                    X_QUERY_REC,
                                    X_QUERY_COMPR,
                                    X_COMENTARIOS,
                                    C_USUARIO,    
                                    FH_ALTA)
      SELECT SLU.S_HCONJUNTO_GC.NEXTVAL,
             BCG.O_CONJUNTO,   
             BCG.C_CONJUNTO,  
             BCG.XC_CONJUNTO,  
             BCG.XL_CONJUNTO, 
             'NEW',
             BCG.X_QUERY_COUNT,
             BCG.X_QUERY_REC,
             BCG.X_QUERY_COMPR,
             BCG.X_COMENTARIOS,
             slu.obtener_usuario,    
             slu.spap_fecha.fecha_bd
      FROM   SLU.BCONJUNTO_GC BCG
      WHERE  O_CONJUNTO = rec_datos_conjuntos_gc.o_conjunto;
   END LOOP;
END;
/
