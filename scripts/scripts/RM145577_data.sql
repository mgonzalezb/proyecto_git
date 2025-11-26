BEGIN
      IF
      cg_spa_asientos_contables.SFN_Generacion_Automatica (2025,  --aa_formulario
                                                           'NB', --t_formulario
                                                           2077,  --o_formulario
                                                           null,   --p_servicio
                                                           'A'    --p_estado
                                                           ) != 'SI' THEN
         dbms_output.put_line('Error!');
      ELSE
         dbms_output.put_line('GENERADO');
      END IF;
EXCEPTION
    --
    WHEN ING_SPAR_MANEJO_ERROR.Error_No_Esperado OR ING_SPAR_MANEJO_ERROR.Error_Esperado THEN
        dbms_output.put_line(' ERROR ');
        dbms_output.put_line(ING_SPAR_MANEJO_ERROR.get_x_debug);
        dbms_output.put_line(SUBSTR(ING_SPAR_MANEJO_ERROR.get_x_error, 1, 250));
        dbms_output.put_line(SUBSTR(ING_SPAR_MANEJO_ERROR.get_x_error, 500, 250));
        dbms_output.put_line(SUBSTR(ING_SPAR_MANEJO_ERROR.get_x_error, 250, 250));
        dbms_output.put_line(SUBSTR(ING_SPAR_MANEJO_ERROR.get_x_error, 750, 250));
        ROLLBACK WORK;
        --
   WHEN OTHERS THEN
        --
        dbms_output.put_line(' ERROR ');
dbms_output.put_line(SQLCODE || ' - ' || SQLERRM);
        ROLLBACK WORK;
        --
END;
/